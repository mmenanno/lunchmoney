# typed: strict
# frozen_string_literal: true

require_relative "errors"
require_relative "config"

require_relative "base_api_call"
require_relative "user/user_calls"
require_relative "categories/category_calls"
require_relative "tags/tag_calls"
require_relative "transactions/transaction_calls"

require_relative "objects/recurring_expense"
require_relative "objects/data"
require_relative "objects/budget"
require_relative "objects/asset"
require_relative "objects/plaid_account"
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
  end
end

# module LunchMoney
#   class Api
#     sig do
#       params(
#         start_date: T.nilable(String),
#         debit_as_negative: T.nilable(T::Boolean),
#       ).returns(T::Array[T.any(
#         T::Hash[Symbol, T.untyped],
#         LunchMoney::RecurringExpense,
#       )])
#     end
#     def recurring_expenses(start_date: nil, debit_as_negative: nil)
#       params = {}
#       params[:start_date] = start_date if start_date
#       params[:debit_as_negative] = debit_as_negative if debit_as_negative

#       response = if params.empty?
#         get("recurring_expenses")
#       else
#         get("recurring_expenses", query_params: params)
#       end

#       errors(response)

#       response.body[:recurring_expenses].map { |recurring_expense| LunchMoney::RecurringExpense.new(recurring_expense) }
#     end

#     sig { params(start_date: String, end_date: String).returns(T.untyped) }
#     def budsummary(start_date:, end_date:)
#       params = {
#         start_date: start_date,
#         end_date: end_date,
#       }
#       response = get("budgets", query_params: params)
#       errors(response)

#       response.body

#       # TODO: below code is for use_structs path, however with changes to the
#       # endpoint I do not have the documenation yet to finish that version
#       response.body.map do |budget|
#         budget[:data].each do |key, value|
#           budget[:data][key] = LunchMoney::Data.new(value)
#         end

#         LunchMoney::Budget.new(budget)
#       end
#     end

#     sig { params(body: T.untyped).returns(T.untyped) }
#     def upsert_budget(body)
#       # TODO
#       # response = put("budgets", body)
#       # errors(response)
#       # response.body
#     end

#     sig { returns(T.untyped) }
#     def remove_budget
#       # TODO
#       # response = delete("budgets")
#       # response.body
#     end

#     sig { returns(T.untyped) }
#     def all_assets
#       response = get("assets")

#       errors(response)

#       response.body[:assets].map { |asset| LunchMoney::Asset.new(asset) }
#     end

#     sig do
#       params(
#         asset_id: T.any(Integer, String),
#         type_name: T.nilable(String),
#         subtype_name: T.nilable(String),
#         name: T.nilable(String),
#         balance: T.nilable(String),
#         balance_as_of: T.nilable(String),
#         currency: T.nilable(String),
#         institution_name: T.nilable(String),
#       ).returns(T.untyped)
#     end
#     def update_asset(asset_id, type_name: nil, subtype_name: nil, name: nil, balance: nil,
#       balance_as_of: nil, currency: nil, institution_name: nil)
#       params = {}
#       params[:type_name] = type_name if type_name
#       params[:subtype_name] = subtype_name if subtype_name
#       params[:name] = name if name
#       params[:balance] = balance if balance
#       params[:balance_as_of] = balance_as_of if balance_as_of
#       params[:currency] = currency if currency
#       params[:institution_name] = institution_name if institution_name

#       response = put("assets/#{asset_id}", params)

#       errors(response)

#       LunchMoney::Asset.new(response.body)
#     end

#     sig { returns(T.untyped) }
#     def all_plaid_accounts
#       response = get("plaid_accounts")

#       errors(response)

#       response.body[:plaid_accounts].map { |plaid_account| LunchMoney::PlaidAccount.new(plaid_account) }
#     end

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
