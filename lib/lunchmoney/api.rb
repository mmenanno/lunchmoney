# typed: strict
# frozen_string_literal: true

require_relative "errors"
require_relative "config"

require_relative "base_api_call"
require_relative "user/user_calls"
require_relative "categories/category_calls"
require_relative "tags/tag_calls"
require_relative "transactions/transaction_calls"
require_relative "recurring_expenses/recurring_expense_calls"
require_relative "budget/budget_calls"
require_relative "assets/asset_calls"
require_relative "plaid_accounts/plaid_account_calls"

require_relative "objects/crypto"

module LunchMoney
  class Api
    sig { returns(T.nilable(String)) }
    attr_accessor :api_key

    sig { params(api_key: T.nilable(String)).void }
    def initialize(api_key: nil)
      @api_key = T.let(api_key || LunchMoney::Config.token, T.nilable(String))
    end

    delegate :user, to: :user_calls

    sig { returns(LunchMoney::UserCalls) }
    def user_calls
      @user_calls ||= T.let(LunchMoney::UserCalls.new(api_key:), T.nilable(LunchMoney::UserCalls))
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

    sig { returns(LunchMoney::CategoryCalls) }
    def category_calls
      @category_calls ||= T.let(LunchMoney::CategoryCalls.new(api_key:), T.nilable(LunchMoney::CategoryCalls))
    end

    delegate :all_tags, to: :tag_calls

    sig { returns(LunchMoney::TagCalls) }
    def tag_calls
      @tag_calls ||= T.let(LunchMoney::TagCalls.new(api_key:), T.nilable(LunchMoney::TagCalls))
    end

    delegate :transactions,
      :single_transaction,
      :insert_transactions,
      :update_transaction,
      :unsplit_transaction,
      :create_transaction_group,
      :delete_transaction_group,
      to: :transaction_calls

    sig { returns(LunchMoney::TransactionCalls) }
    def transaction_calls
      @transaction_calls ||= T.let(LunchMoney::TransactionCalls.new(api_key:), T.nilable(LunchMoney::TransactionCalls))
    end

    delegate :recurring_expenses, to: :recurring_expense_calls

    sig { returns(LunchMoney::RecurringExpenseCalls) }
    def recurring_expense_calls
      @recurring_expense_calls ||= T.let(
        LunchMoney::RecurringExpenseCalls.new(api_key:),
        T.nilable(LunchMoney::RecurringExpenseCalls),
      )
    end

    delegate :budget_summary, :upsert_budget, :remove_budget, to: :budget_calls

    sig { returns(LunchMoney::BudgetCalls) }
    def budget_calls
      @budget_calls ||= T.let(LunchMoney::BudgetCalls.new(api_key:), T.nilable(LunchMoney::BudgetCalls))
    end

    delegate :assets, :create_asset, :update_asset, to: :asset_calls

    sig { returns(LunchMoney::AssetCalls) }
    def asset_calls
      @asset_calls ||= T.let(LunchMoney::AssetCalls.new(api_key:), T.nilable(LunchMoney::AssetCalls))
    end

    delegate :plaid_accounts, to: :plaid_account_calls

    sig { returns(LunchMoney::PlaidAccountCalls) }
    def plaid_account_calls
      @plaid_account_calls ||= T.let(
        LunchMoney::PlaidAccountCalls.new(api_key:),
        T.nilable(LunchMoney::PlaidAccountCalls),
      )
    end
  end
end

# module LunchMoney
#   class Api
#     sig { returns(T.untyped) }
#     def all_crypto
#       response = get("crypto")

#       errors(response)

#       response.body[:crypto].map { |crypto| LunchMoney::Crypto.new(crypto) }
#     end

#     sig do
#       params(
#         crypto_asset_id: T.any(Integer, String),
#         name: T.nilable(String),
#         display_name: T.nilable(String),
#         institution_name: T.nilable(String),
#         balance: T.nilable(T.any(Integer, String)),
#         currency: T.nilable(String),
#       ).returns(T.untyped)
#     end
#     def update_manual_crypto(crypto_asset_id, name: nil, display_name: nil,
#       institution_name: nil, balance: nil, currency: nil)
#       params = {}
#       params[:name] = name if name
#       params[:display_name] = display_name if display_name
#       params[:institution_name] = institution_name if institution_name
#       params[:balance] = balance if balance
#       params[:currency] = currency if currency

#       response = put("crypto/manual/#{crypto_asset_id}", params)

#       errors(response)

#       LunchMoney::Asset.new(response.body)
#     end
#   end
# end
