# Changelog

All notable changes to the `lunchmoney` gem will be documented in this file.

## [2.0.0.rc1] - Unreleased

First release candidate for gem v2, targeting the LunchMoney v2 API.
See [UPGRADING.md](UPGRADING.md) for a detailed migration guide from v1.

### Breaking Changes

- **Error handling**: API errors now raise exceptions (`LunchMoney::ApiError`
  and subclasses) instead of returning `LunchMoney::Errors` objects
- **Base URL**: Changed from `https://dev.lunchmoney.app/v1/` to
  `https://api.lunchmoney.dev/v2`
- **Assets renamed to Manual Accounts**: All `asset` methods renamed to
  `manual_account` equivalents
- **Transaction field renames**: `asset_id` -> `manual_account_id`,
  `tags` -> `tag_ids`, `has_children` -> `is_split_parent`, and others
- **Transaction status values**: `cleared` -> `reviewed`,
  `uncleared` -> `unreviewed`
- **Dehydrated responses**: Responses contain IDs instead of nested objects
  (e.g., no more `category_name` on transactions)
- **Budgets replaced by Summary**: `api.budgets` replaced with `api.summary`
  returning aligned/non-aligned response types
- **DELETE operations**: Now return `nil` (204 No Content) instead of `true`
- **Faraday minimum version**: Bumped to `>= 2.0`

### Added

- Tags CRUD: `create_tag`, `update_tag`, `delete_tag`
- Transaction delete: `delete_transaction`
- Bulk operations: `update_transactions`, `delete_transactions`
- Transaction attachments: `attach_file`, `attachment_url`,
  `delete_attachment`
- Individual resource get: `manual_account(id)`, `plaid_account(id)`,
  `recurring_item(id)`
- Auto-pagination for transactions via `Enumerable` enumerator
- Rate limit tracking: `api.rate_limit` with `remaining`, `exhausted?`
- Rate limit info on all `ApiError` exceptions
- Raw HTTP response access on exceptions via `error.response`
- Lazy hydration methods on model objects (e.g., `txn.category(client: api)`)
- Client-side validation (`validate!`) on request objects
- Safe coercions (Float amount -> String, String ID -> Integer)
- Model objects auto-generated from OpenAPI spec
- `faraday-multipart` dependency for attachment uploads
- OpenAPI spec at `openapi/v2.yaml`
- Automated GitHub Action for spec update detection

### Removed

- `sorbet-runtime` dependency and all Sorbet type annotations
- VCR and cassette-based testing (replaced with WebMock + spec-derived fixtures)
- `crypto` endpoint (removed from v2 API)
- `recurring_expenses` endpoint (was deprecated, removed from v2 API)
- `LunchMoney::Errors` return type (replaced by exceptions)
- `debit_as_negative` parameter
- `display_name`, `display_notes` transaction fields
- CodeClimate configuration
- YARD documentation generation
- SECURITY.md
