# typed: strict
# frozen_string_literal: true

require_relative "exceptions"
require_relative "config"

require_relative "api_call"
require_relative "user/user_calls"
require_relative "categories/category_calls"
require_relative "tags/tag_calls"
require_relative "transactions/transaction_calls"
require_relative "recurring_expenses/recurring_expense_calls"
require_relative "budget/budget_calls"
require_relative "assets/asset_calls"
require_relative "plaid_accounts/plaid_account_calls"
require_relative "crypto/crypto_calls"

module LunchMoney
  class Api
    sig { returns(T.nilable(String)) }
    attr_reader :api_key

    sig { params(api_key: T.nilable(String)).void }
    def initialize(api_key: nil)
      @api_key = T.let(api_key || LunchMoney::Config.token, T.nilable(String))
    end

    delegate :user, to: :user_calls

    sig { returns(LunchMoney::ApiCall) }
    def user_calls
      with_valid_api_key do
        @user_calls ||= T.let(LunchMoney::UserCalls.new(api_key:), T.nilable(LunchMoney::UserCalls))
      end
    end

    delegate :all_categories,
      :single_category,
      :create_category,
      :create_category_group,
      :update_category,
      :add_to_category_group,
      :delete_category,
      :force_delete_category,
      to: :category_calls

    sig { returns(LunchMoney::ApiCall) }
    def category_calls
      with_valid_api_key do
        @category_calls ||= T.let(LunchMoney::CategoryCalls.new(api_key:), T.nilable(LunchMoney::CategoryCalls))
      end
    end

    delegate :all_tags, to: :tag_calls

    sig { returns(LunchMoney::ApiCall) }
    def tag_calls
      with_valid_api_key do
        @tag_calls ||= T.let(LunchMoney::TagCalls.new(api_key:), T.nilable(LunchMoney::TagCalls))
      end
    end

    delegate :transactions,
      :single_transaction,
      :insert_transactions,
      :update_transaction,
      :unsplit_transaction,
      :create_transaction_group,
      :delete_transaction_group,
      to: :transaction_calls

    sig { returns(LunchMoney::ApiCall) }
    def transaction_calls
      with_valid_api_key do
        @transaction_calls ||= T.let(
          LunchMoney::TransactionCalls.new(api_key:),
          T.nilable(LunchMoney::TransactionCalls),
        )
      end
    end

    delegate :recurring_expenses, to: :recurring_expense_calls

    sig { returns(LunchMoney::ApiCall) }
    def recurring_expense_calls
      with_valid_api_key do
        @recurring_expense_calls ||= T.let(
          LunchMoney::RecurringExpenseCalls.new(api_key:),
          T.nilable(LunchMoney::RecurringExpenseCalls),
        )
      end
    end

    delegate :budget_summary, :upsert_budget, :remove_budget, to: :budget_calls

    sig { returns(LunchMoney::ApiCall) }
    def budget_calls
      with_valid_api_key do
        @budget_calls ||= T.let(LunchMoney::BudgetCalls.new(api_key:), T.nilable(LunchMoney::BudgetCalls))
      end
    end

    delegate :assets, :create_asset, :update_asset, to: :asset_calls

    sig { returns(LunchMoney::ApiCall) }
    def asset_calls
      with_valid_api_key do
        @asset_calls ||= T.let(LunchMoney::AssetCalls.new(api_key:), T.nilable(LunchMoney::AssetCalls))
      end
    end

    delegate :plaid_accounts, to: :plaid_account_calls

    sig { returns(LunchMoney::ApiCall) }
    def plaid_account_calls
      with_valid_api_key do
        @plaid_account_calls ||= T.let(
          LunchMoney::PlaidAccountCalls.new(api_key:),
          T.nilable(LunchMoney::PlaidAccountCalls),
        )
      end
    end

    delegate :crypto, :update_crypto, to: :crypto_calls

    sig { returns(LunchMoney::ApiCall) }
    def crypto_calls
      with_valid_api_key do
        @crypto_calls ||= T.let(LunchMoney::CryptoCalls.new(api_key:), T.nilable(LunchMoney::CryptoCalls))
      end
    end

    private

    sig { params(block: T.proc.returns(LunchMoney::ApiCall)).returns(LunchMoney::ApiCall) }
    def with_valid_api_key(&block)
      raise(InvalidApiKey, "API key is missing or invalid") if api_key.blank?

      yield
    end
  end
end
