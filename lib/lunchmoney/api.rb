# typed: strict
# frozen_string_literal: true

require_relative "exceptions"
require_relative "configuration"

require_relative "calls/base"
require_relative "objects/object"
require_relative "calls/users"
require_relative "calls/categories"
require_relative "calls/tags"
require_relative "calls/transactions"
require_relative "calls/recurring_expenses"
require_relative "calls/budgets"
require_relative "calls/assets"
require_relative "calls/plaid_accounts"
require_relative "calls/crypto"

module LunchMoney
  # The main API class that a user should interface through the method of any individual call is delegated through here
  # so that it is never necessary to go through things like `LunchMoney::Calls::Users.new.user` instead you can directly
  # call the endpoint with LunchMoney::Api.new.user and it will be delegated to the correct call.
  class Api
    sig { returns(T.nilable(String)) }
    attr_reader :api_key

    sig { params(api_key: T.nilable(String)).void }
    def initialize(api_key: nil)
      @api_key = T.let((api_key || LunchMoney.configuration.api_key), T.nilable(String))
    end

    delegate :me, to: :user_calls

    sig { returns(LunchMoney::Calls::Base) }
    def user_calls
      with_valid_api_key do
        @user_calls ||= T.let(LunchMoney::Calls::Users.new(api_key:), T.nilable(LunchMoney::Calls::Users))
      end
    end

    delegate :categories,
      :category,
      :create_category,
      :create_category_group,
      :update_category,
      :add_to_category_group,
      :delete_category,
      :force_delete_category,
      to: :category_calls

    sig { returns(LunchMoney::Calls::Base) }
    def category_calls
      with_valid_api_key do
        @category_calls ||= T.let(LunchMoney::Calls::Categories.new(api_key:), T.nilable(LunchMoney::Calls::Categories))
      end
    end

    delegate :tags, to: :tag_calls

    sig { returns(LunchMoney::Calls::Base) }
    def tag_calls
      with_valid_api_key do
        @tag_calls ||= T.let(LunchMoney::Calls::Tags.new(api_key:), T.nilable(LunchMoney::Calls::Tags))
      end
    end

    delegate :transactions,
      :transaction,
      :insert_transactions,
      :update_transaction,
      :unsplit_transaction,
      :transaction_group,
      :create_transaction_group,
      :delete_transaction_group,
      to: :transaction_calls

    sig { returns(LunchMoney::Calls::Base) }
    def transaction_calls
      with_valid_api_key do
        @transaction_calls ||= T.let(
          LunchMoney::Calls::Transactions.new(api_key:),
          T.nilable(LunchMoney::Calls::Transactions),
        )
      end
    end

    delegate :recurring_expenses, to: :recurring_expense_calls

    sig { returns(LunchMoney::Calls::Base) }
    def recurring_expense_calls
      with_valid_api_key do
        @recurring_expense_calls ||= T.let(
          LunchMoney::Calls::RecurringExpenses.new(api_key:),
          T.nilable(LunchMoney::Calls::RecurringExpenses),
        )
      end
    end

    delegate :budgets, :upsert_budget, :remove_budget, to: :budget_calls

    sig { returns(LunchMoney::Calls::Base) }
    def budget_calls
      with_valid_api_key do
        @budget_calls ||= T.let(LunchMoney::Calls::Budgets.new(api_key:), T.nilable(LunchMoney::Calls::Budgets))
      end
    end

    delegate :assets, :create_asset, :update_asset, to: :asset_calls

    sig { returns(LunchMoney::Calls::Base) }
    def asset_calls
      with_valid_api_key do
        @asset_calls ||= T.let(LunchMoney::Calls::Assets.new(api_key:), T.nilable(LunchMoney::Calls::Assets))
      end
    end

    delegate :plaid_accounts, :plaid_accounts_fetch, to: :plaid_account_calls

    sig { returns(LunchMoney::Calls::Base) }
    def plaid_account_calls
      with_valid_api_key do
        @plaid_account_calls ||= T.let(
          LunchMoney::Calls::PlaidAccounts.new(api_key:),
          T.nilable(LunchMoney::Calls::PlaidAccounts),
        )
      end
    end

    delegate :crypto, :update_crypto, to: :crypto_calls

    sig { returns(LunchMoney::Calls::Base) }
    def crypto_calls
      with_valid_api_key do
        @crypto_calls ||= T.let(LunchMoney::Calls::Crypto.new(api_key:), T.nilable(LunchMoney::Calls::Crypto))
      end
    end

    private

    sig { params(block: T.proc.returns(LunchMoney::Calls::Base)).returns(LunchMoney::Calls::Base) }
    def with_valid_api_key(&block)
      raise(InvalidApiKey, "API key is missing or invalid") if api_key.blank?

      yield
    end
  end
end
