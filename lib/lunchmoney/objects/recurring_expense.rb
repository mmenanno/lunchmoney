# typed: strict
# frozen_string_literal: true

require_relative "recurring_expense_base"
module LunchMoney
  module Objects
    # https://lunchmoney.dev/#recurring-expenses-object
    class RecurringExpense < RecurringExpenseBase
      sig { returns(Integer) }
      attr_accessor :id

      sig { returns(T.nilable(String)) }
      attr_accessor :start_date, :end_date, :description, :original_name

      sig { returns(String) }
      attr_accessor :cadence, :billing_date, :type, :source, :created_at

      sig { returns(T.nilable(Integer)) }
      attr_accessor :plaid_account_id, :asset_id, :transaction_id, :category_id

      sig do
        params(
          cadence: String,
          payee: String,
          amount: String,
          currency: String,
          billing_date: String,
          type: String,
          source: String,
          id: Integer,
          created_at: String,
          category_id: T.nilable(Integer),
          start_date: T.nilable(String),
          end_date: T.nilable(String),
          description: T.nilable(String),
          original_name: T.nilable(String),
          plaid_account_id: T.nilable(Integer),
          asset_id: T.nilable(Integer),
          transaction_id: T.nilable(Integer),
          to_base: T.nilable(Number),
        ).void
      end
      def initialize(cadence:, payee:, amount:, currency:, billing_date:, type:, source:, id:, created_at:,
        category_id: nil, start_date: nil, end_date: nil, description: nil, original_name: nil, plaid_account_id: nil,
        asset_id: nil, transaction_id: nil, to_base: nil)
        super(payee:, amount:, currency:, to_base:)
        @cadence = cadence
        @payee = payee
        @amount = amount
        @currency = currency
        @billing_date = billing_date
        @type = type
        @source = source
        @id = id
        @category_id = category_id
        @created_at = created_at
        @start_date = start_date
        @end_date = end_date
        @description = description
        @original_name = original_name
        @plaid_account_id = plaid_account_id
        @asset_id = asset_id
        @transaction_id = transaction_id
        @to_base = to_base
      end
    end
  end
end
