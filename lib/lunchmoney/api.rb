# frozen_string_literal: true

require_relative "client/base"
require_relative "objects/base"

# Object models
require_relative "objects/user"
require_relative "objects/category"
require_relative "objects/child_category"
require_relative "objects/tag"
require_relative "objects/create_tag"
require_relative "objects/update_tag"
require_relative "objects/delete_tag_response_with_dependencies"
require_relative "objects/transaction"
require_relative "objects/child_transaction"
require_relative "objects/insert_transaction"
require_relative "objects/insert_transactions_response"
require_relative "objects/skipped_duplicate"
require_relative "objects/update_transaction"
require_relative "objects/split_transaction"
require_relative "objects/transaction_attachment"
require_relative "objects/manual_account"
require_relative "objects/create_manual_account"
require_relative "objects/update_manual_account"
require_relative "objects/plaid_account"
require_relative "objects/recurring_item"
require_relative "objects/error_response"
require_relative "objects/create_category"
require_relative "objects/update_category"
require_relative "objects/delete_category_response_with_dependencies"

# Summary models
require_relative "objects/summary/summary_totals"
require_relative "objects/summary/summary_totals_breakdown"
require_relative "objects/summary/summary_category_occurrence"
require_relative "objects/summary/summary_recurring_transaction"
require_relative "objects/summary/summary_rollover_pool"
require_relative "objects/summary/summary_rollover_pool_adjustment"
require_relative "objects/summary/aligned_category_totals"
require_relative "objects/summary/non_aligned_category_totals"
require_relative "objects/summary/aligned_summary_category"
require_relative "objects/summary/non_aligned_summary_category"
require_relative "objects/summary/aligned_summary_response"
require_relative "objects/summary/non_aligned_summary_response"

# Enum modules
require_relative "objects/enums/account_type"
require_relative "objects/enums/currency"
require_relative "objects/enums/plaid_account_status"
require_relative "objects/enums/recurring_granularity"
require_relative "objects/enums/recurring_source"
require_relative "objects/enums/recurring_status"
require_relative "objects/enums/transaction_source"
require_relative "objects/enums/transaction_status"

# Call modules
require_relative "calls/base"
require_relative "calls/me"
require_relative "calls/categories"
require_relative "calls/tags"
require_relative "calls/transactions"
require_relative "calls/transactions/split"
require_relative "calls/transactions/group"
require_relative "calls/transactions/bulk"
require_relative "calls/transactions/attachments"
require_relative "calls/manual_accounts"
require_relative "calls/plaid_accounts"
require_relative "calls/recurring_items"
require_relative "calls/summary"

module LunchMoney
  # Main API client. Inherits HTTP capabilities from Client::Base
  # and includes all call modules for API endpoint methods.
  #
  # @example Initialize with explicit API key
  #   api = LunchMoney::Api.new(api_key: "your_key")
  #
  # @example Initialize from configuration
  #   LunchMoney.configure { |c| c.api_key = "your_key" }
  #   api = LunchMoney::Api.new
  class Api < Client::Base
    include Calls::Me
    include Calls::Categories
    include Calls::Tags
    include Calls::Transactions
    include Calls::Transactions::Split
    include Calls::Transactions::Group
    include Calls::Transactions::Bulk
    include Calls::Transactions::Attachments
    include Calls::ManualAccounts
    include Calls::PlaidAccounts
    include Calls::RecurringItems
    include Calls::Summary
  end
end
