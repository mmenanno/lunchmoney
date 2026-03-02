# lunchmoney

[![Gem Version](https://badge.fury.io/rb/lunchmoney.svg)](https://badge.fury.io/rb/lunchmoney)
[![CI](https://github.com/mmenanno/lunchmoney/actions/workflows/ci.yml/badge.svg)](https://github.com/mmenanno/lunchmoney/actions/workflows/ci.yml)

Ruby client for the [LunchMoney API v2](https://alpha.lunchmoney.dev/v2/docs).
Wraps all v2 endpoints with idiomatic Ruby: model objects auto-generated from
the OpenAPI spec, exception-based error handling, auto-pagination, lazy
hydration, and rate limit tracking.

## Installation

Add to your Gemfile:

```ruby
gem "lunchmoney", "~> 2.0"
```

Requires Ruby 3.2+.

## Configuration

```ruby
# Option 1: Configure block
LunchMoney.configure do |config|
  config.api_key = "your_api_key"
end
api = LunchMoney::Api.new

# Option 2: Environment variable (LUNCHMONEY_TOKEN)
api = LunchMoney::Api.new

# Option 3: Per-instance
api = LunchMoney::Api.new(api_key: "your_api_key")
```

## Quick Start

```ruby
api = LunchMoney::Api.new(api_key: "your_api_key")

# Get current user
user = api.me
puts user.name

# List transactions (auto-paginates)
api.transactions(start_date: "2025-01-01", end_date: "2025-12-31").each do |txn|
  puts "#{txn.date}: #{txn.payee} #{txn.amount}"
end

# Create a transaction
txn = api.create_transaction(
  date: "2025-06-15",
  amount: "12.50",
  payee: "Coffee Shop",
  category_id: 42
)

# Update a transaction
api.update_transaction(txn.id, notes: "Morning coffee")

# Delete a transaction
api.delete_transaction(txn.id)
```

## Resources

### User

```ruby
user = api.me
user.id      # => 12345
user.name    # => "Jane Doe"
user.email   # => "jane@example.com"
```

### Transactions

```ruby
# List with auto-pagination
api.transactions(start_date: "2025-01-01", end_date: "2025-01-31").each do |txn|
  puts txn.payee
end

# Fetch a single page manually
page = api.transactions_page(start_date: "2025-01-01", end_date: "2025-01-31", limit: 100, offset: 0)
page[:transactions] # => [Transaction, ...]
page[:has_more]     # => true/false

# Get a single transaction
txn = api.transaction(123)

# Create
api.create_transaction(date: "2025-06-15", amount: "25.00", payee: "Grocery Store")

# Create multiple
api.create_transactions([
  { date: "2025-06-15", amount: "25.00", payee: "Grocery Store" },
  { date: "2025-06-15", amount: "5.00", payee: "Parking" },
], apply_rules: true, skip_duplicates: true)

# Update
api.update_transaction(123, notes: "Updated note", category_id: 7)

# Delete
api.delete_transaction(123)
```

#### Split Transactions

```ruby
# Split a transaction into parts
children = api.split_transaction(123, [
  { amount: "10.00", category_id: 1 },
  { amount: "15.00", category_id: 2 },
])

# Unsplit
api.unsplit_transaction(123)
```

#### Group Transactions

```ruby
# Group transactions under a new parent
group = api.group_transactions(
  transaction_ids: [101, 102, 103],
  date: "2025-06-15",
  payee: "Weekend Trip"
)

# Ungroup
api.ungroup_transactions(group.id)
```

#### Bulk Operations

```ruby
# Bulk update
api.update_transactions([
  { id: 101, category_id: 5 },
  { id: 102, category_id: 5 },
])

# Bulk delete
api.delete_transactions([101, 102, 103])
```

#### Attachments

```ruby
# List attachments for a transaction
attachments = api.attachments(transaction_id: 123)

# Upload a file
attachment = api.attach_file(transaction_id: 123, file_path: "/path/to/receipt.pdf", notes: "Dinner receipt")

# Get download URL
attachment = api.attachment_url(attachment.id)

# Delete
api.delete_attachment(attachment.id)
```

### Categories

```ruby
# List all categories
categories = api.categories
categories = api.categories(format: :nested)    # hierarchical
categories = api.categories(format: :flattened)  # flat list

# Get a single category
category = api.category(42)

# Create
api.create_category(name: "Subscriptions", description: "Monthly subscriptions")

# Create a category group
api.create_category(name: "Entertainment", is_group: true, category_ids: [1, 2, 3])

# Update
api.update_category(42, name: "Software Subscriptions")

# Delete
api.delete_category(42)
```

### Tags

```ruby
# List all tags
tags = api.tags

# Get a single tag
tag = api.tag(5)

# Create
api.create_tag(name: "Business", description: "Business expenses")

# Update
api.update_tag(5, name: "Work")

# Delete
api.delete_tag(5)
```

### Manual Accounts

Formerly called "assets" in v1.

```ruby
# List all manual accounts
accounts = api.manual_accounts

# Get a single account
account = api.manual_account(10)

# Create
api.create_manual_account(name: "Cash", type: "cash", balance: "500.00")

# Update
api.update_manual_account(10, balance: "450.00")

# Delete
api.delete_manual_account(10)
```

### Plaid Accounts

```ruby
# List all Plaid-connected accounts
accounts = api.plaid_accounts

# Get a single account
account = api.plaid_account(20)

# Trigger a data fetch from Plaid
api.plaid_accounts_fetch(start_date: "2025-01-01", end_date: "2025-01-31")
```

### Recurring Items

```ruby
# List recurring items
items = api.recurring_items(start_date: "2025-01-01", end_date: "2025-12-31")

# Get a single recurring item
item = api.recurring_item(30, start_date: "2025-01-01", end_date: "2025-12-31")
```

### Summary

Replaces the v1 budgets endpoint. Returns either an aligned or non-aligned
response depending on whether the date range matches your budget period.

```ruby
summary = api.summary(start_date: "2025-01-01", end_date: "2025-01-31")
```

## Error Handling

All API errors raise exceptions. Use `rescue` to handle them:

```ruby
begin
  api.transaction(999999)
rescue LunchMoney::NotFoundError => e
  puts "Not found: #{e.message}"
rescue LunchMoney::RateLimitError => e
  puts "Rate limited, retry after #{e.retry_after} seconds"
rescue LunchMoney::ValidationError => e
  puts "Invalid request: #{e.message}"
  e.errors.each { |err| puts err }
rescue LunchMoney::AuthenticationError => e
  puts "Bad API key: #{e.message}"
rescue LunchMoney::ServerError => e
  puts "Server error #{e.status_code}: #{e.message}"
rescue LunchMoney::ApiError => e
  # Catch-all for any API error
  puts "API error #{e.status_code}: #{e.message}"
end
```

### Exception Hierarchy

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

## Rate Limits

Rate limit information is updated after every API call:

```ruby
api.transactions(start_date: "2025-01-01", end_date: "2025-01-31").first(5)

api.rate_limit.limit      # => 350
api.rate_limit.remaining  # => 349
api.rate_limit.reset      # => seconds until reset
api.rate_limit.exhausted? # => false
```

When the limit is exceeded, the client raises `LunchMoney::RateLimitError` with
a `retry_after` value in seconds. The built-in Faraday retry middleware also
automatically retries 429 responses.

## Auto-Pagination

The `transactions` method returns a lazy `Enumerable` that fetches pages on
demand:

```ruby
# Iterates through all matching transactions, fetching pages as needed
api.transactions(start_date: "2025-01-01", end_date: "2025-12-31").each do |txn|
  puts txn.payee
end

# Works with Enumerable methods
first_ten = api.transactions(start_date: "2025-01-01", end_date: "2025-12-31").first(10)

# Filter with lazy evaluation
large = api.transactions(start_date: "2025-01-01", end_date: "2025-12-31")
  .lazy
  .select { |t| t.amount.to_f > 100 }
  .first(5)
```

For manual control, use `transactions_page` directly:

```ruby
page = api.transactions_page(start_date: "2025-01-01", end_date: "2025-01-31", limit: 100, offset: 0)
page[:transactions] # => [Transaction, ...]
page[:has_more]     # => true/false
```

## Lazy Hydration

V2 API responses are "dehydrated" — they contain IDs instead of nested objects.
For example, transactions have `category_id` and `tag_ids` instead of full
category and tag objects.

Model objects provide convenience methods that fetch related objects on demand
and cache the result:

```ruby
txn = api.transaction(123)

txn.category_id  # => 42 (always available)

# Fetch the full category object (makes an API call, then caches)
category = txn.category(client: api)
category.name  # => "Groceries"

# Fetch related tags
tags = txn.tags(client: api)
tags.map(&:name)  # => ["Food", "Weekly"]

# Fetch the account
account = txn.manual_account(client: api)
```

The `client:` keyword is required so hydration calls use your authenticated API
instance. Results are cached on the object — subsequent calls return the cached
value without additional API requests.

## Client-Side Validation

Request objects validate their fields before sending to the API. This catches
common mistakes locally without an HTTP round-trip:

```ruby
begin
  api.create_transaction(date: nil, amount: "10.00", payee: "Test")
rescue LunchMoney::ClientValidationError => e
  puts e.message  # => "date is required"
end

begin
  api.create_transaction(
    date: "2025-01-01",
    amount: "10.00",
    payee: "A" * 141  # exceeds 140-char limit
  )
rescue LunchMoney::ClientValidationError => e
  puts e.message  # => "payee must be at most 140 characters"
end
```

Validated fields include required attributes, string length limits, enum values,
and JSON size constraints.

## Development

### Setup

```bash
bundle install
```

### Running Tests

```bash
toys test
```

### Linting

```bash
toys rubocop    # or: toys style
```

### Code Coverage

```bash
toys coverage   # or: toys cov
```

### Regenerating Models from OpenAPI Spec

```bash
toys generate models
```

### Full CI Suite

```bash
toys ci
```

## Upgrading from v1

See [UPGRADING.md](UPGRADING.md) for the full migration guide from gem v1
(API v1) to gem v2 (API v2).

## Contributing

Bug reports and pull requests are welcome on
[GitHub](https://github.com/mmenanno/lunchmoney).

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
