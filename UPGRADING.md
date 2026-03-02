# Upgrading from v1 to v2

This guide covers migrating from `lunchmoney` gem v1 (LunchMoney API v1) to
gem v2 (LunchMoney API v2).

## Breaking Changes

### Error Handling

The most significant change: API errors now raise exceptions instead of
returning error objects.

**v1:**

```ruby
response = api.categories
if response.is_a?(LunchMoney::Errors)
  puts response.messages
end
```

**v2:**

```ruby
begin
  categories = api.categories
rescue LunchMoney::ApiError => e
  puts e.message
  puts e.status_code
  e.errors.each { |err| puts err }
end
```

Exception hierarchy:

```text
LunchMoney::Error < StandardError
├── LunchMoney::ApiError            (all HTTP errors)
│   ├── AuthenticationError         (401)
│   ├── NotFoundError               (404)
│   ├── ValidationError             (400, 422)
│   ├── RateLimitError              (429, includes retry_after)
│   └── ServerError                 (5xx)
├── LunchMoney::ClientValidationError  (client-side validation failures)
├── LunchMoney::ConfigurationError
│   └── LunchMoney::InvalidApiKey
```

Every `ApiError` exposes: `status_code`, `message`, `errors`, `response` (raw
Faraday response), and `rate_limit`.

### Renamed Endpoints

| v1 | v2 |
| --- | --- |
| `api.assets` | `api.manual_accounts` |
| `api.asset(id)` | `api.manual_account(id)` |
| `api.create_asset(...)` | `api.create_manual_account(...)` |
| `api.update_asset(id, ...)` | `api.update_manual_account(id, ...)` |
| `api.budgets(...)` | `api.summary(start_date:, end_date:)` |

### Removed Endpoints

- `api.crypto` — removed from the v2 API entirely
- `api.recurring_expenses` — was already deprecated, use `api.recurring_items`

### Transaction Field Renames

| v1 field | v2 field |
| --- | --- |
| `asset_id` | `manual_account_id` |
| `tags` | `tag_ids` (array of IDs, not tag objects) |
| `has_children` | `is_split_parent` |
| `parent_id` | `split_parent_id` |
| `is_group` | `is_group_parent` |
| `group_id` | `group_parent_id` |
| `display_name` | removed |
| `display_notes` | removed |
| `category_name` | removed (use [lazy hydration](#dehydrated-responses)) |
| `category_group_id` | removed (use [lazy hydration](#dehydrated-responses)) |
| `asset_name` | removed (use [lazy hydration](#dehydrated-responses)) |

### Transaction Status Changes

| v1 status | v2 status |
| --- | --- |
| `cleared` | `reviewed` |
| `uncleared` | `unreviewed` |
| `pending` | removed |
| `recurring` | removed |

Update any code that filters or sets transaction status values.

### User Object Renames

| v1 field | v2 field |
| --- | --- |
| `user_id` | `id` |
| `user_name` | `name` |
| `user_email` | `email` |

### Manual Account Object Renames

Formerly called "Asset" in v1.

| v1 field | v2 field |
| --- | --- |
| `type_name` | `type` |
| `subtype_name` | `subtype` |
| `exclude_transactions` | `exclude_from_transactions` |

The type value `depository` has been renamed to `cash`.

### Recurring Item Object Changes

| v1 field | v2 field |
| --- | --- |
| `billing_date` | `anchor_date` |
| `occurrences` | `expected_occurrence_dates` |

Several flat properties have been reorganized into nested objects in the v2 API
response structure.

### Dehydrated Responses

V2 API responses are "dehydrated" — they return IDs instead of full nested
objects. For example, a transaction's `tags` field (an array of tag objects) is
now `tag_ids` (an array of integers), and `category_name` is gone entirely.

To access related objects, use lazy hydration:

**v1:**

```ruby
txn = api.transaction(123)
puts txn.category_name        # => "Groceries"
puts txn.tags.first.name      # => "Food"
```

**v2:**

```ruby
txn = api.transaction(123)
puts txn.category_id          # => 42

# Fetch the full object on demand (requires client: kwarg)
category = txn.category(client: api)
puts category.name            # => "Groceries"

tags = txn.tags(client: api)
puts tags.first.name          # => "Food"
```

Results are cached on the object instance — subsequent calls return the cached
value without additional API requests.

### DELETE Return Values

DELETE operations now return `nil` (HTTP 204 No Content) instead of `true`.

**v1:**

```ruby
result = api.delete_category(42)  # => true
```

**v2:**

```ruby
api.delete_category(42)  # => nil
```

### Base URL

Changed from `https://dev.lunchmoney.app/v1/` to
`https://api.lunchmoney.dev/v2`. This is handled automatically by the gem —
no action needed unless you were overriding `base_url`.

## New Features

### Tags CRUD

Tags now support full create, update, and delete operations:

```ruby
tag = api.create_tag(name: "Business", description: "Business expenses")
api.update_tag(tag.id, name: "Work")
api.delete_tag(tag.id)
```

### Transaction Delete

Individual transactions can now be deleted:

```ruby
api.delete_transaction(123)
```

### Bulk Transaction Operations

Update or delete multiple transactions in a single call:

```ruby
api.update_transactions([
  { id: 101, category_id: 5 },
  { id: 102, category_id: 5 },
])

api.delete_transactions([101, 102, 103])
```

### Transaction Attachments

Upload, list, and manage file attachments on transactions:

```ruby
api.attach_file(transaction_id: 123, file_path: "/path/to/receipt.pdf")
attachments = api.attachments(transaction_id: 123)
api.delete_attachment(attachments.first.id)
```

### Rate Limit Tracking

Rate limit information is available after every API call:

```ruby
api.rate_limit.limit      # => 350
api.rate_limit.remaining  # => 349
api.rate_limit.reset      # => seconds until reset
api.rate_limit.exhausted? # => false
```

When the limit is exceeded, `LunchMoney::RateLimitError` is raised with a
`retry_after` value. The built-in Faraday retry middleware also automatically
retries 429 responses.

### Auto-Pagination

The `transactions` method returns a lazy `Enumerable` that fetches pages
on demand:

```ruby
api.transactions(start_date: "2025-01-01", end_date: "2025-12-31").each do |txn|
  puts txn.payee
end

# Use with Enumerable methods
first_ten = api.transactions(start_date: "2025-01-01", end_date: "2025-12-31").first(10)
```

For manual page-by-page control, use `transactions_page`:

```ruby
page = api.transactions_page(start_date: "2025-01-01", end_date: "2025-01-31", limit: 100, offset: 0)
```

### Client-Side Validation

Request objects validate their fields before sending, catching mistakes
without an HTTP round-trip:

```ruby
begin
  api.create_transaction(date: nil, amount: "10.00", payee: "Test")
rescue LunchMoney::ClientValidationError => e
  puts e.message  # => "date is required"
end
```

### Summary (Replaces Budgets)

The `budgets` endpoint has been replaced by `summary`, which returns either
an aligned or non-aligned response depending on the date range:

```ruby
summary = api.summary(start_date: "2025-01-01", end_date: "2025-01-31")
```

### Individual Resource Lookups

New single-resource endpoints that did not exist in v1:

```ruby
api.manual_account(id)
api.plaid_account(id)
api.recurring_item(id, start_date: "2025-01-01", end_date: "2025-12-31")
```

## Dependency Changes

| Change | v1 | v2 |
| --- | --- | --- |
| Removed | `sorbet-runtime` | — |
| Added | — | `faraday-multipart` (~> 1.0) |
| Added | — | `faraday-retry` (~> 2.0) |
| Updated | `faraday` (any) | `faraday` (>= 2.0) |

## Configuration

The configuration interface is unchanged. All three methods still work:

```ruby
# Configure block
LunchMoney.configure { |c| c.api_key = "your_key" }

# Environment variable
# LUNCHMONEY_TOKEN=your_key

# Per-instance
LunchMoney::Api.new(api_key: "your_key")
```

The `debit_as_negative` configuration option has been removed.
