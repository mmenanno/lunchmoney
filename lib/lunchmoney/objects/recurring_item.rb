# typed: strict
# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#recurring-items-object
    class RecurringItem < LunchMoney::Objects::Object
      sig { returns(Integer) }
      attr_accessor :id, :created_by

      sig { returns(String) }
      attr_accessor :payee, :currency, :created_at, :updated_at, :billing_date, :source, :amount, :cadence, :granularity, :date

      sig { returns(T.nilable(String)) }
      attr_accessor :start_date, :end_date, :original_name, :description, :notes

      sig { returns(T.nilable(Integer)) }
      attr_accessor :plaid_account_id, :asset_id, :category_id, :category_group_id, :quantity

      sig { returns(T.nilable(Number)) }
      attr_accessor :to_base

      sig { returns(T::Boolean) }
      attr_accessor :is_income, :exclude_from_totals

      sig { returns(T.nilable(T::Hash[String, T::Array[T.untyped]])) }
      attr_accessor :occurrences

      sig { returns(T.nilable(T::Array[T.untyped])) }
      attr_accessor :transactions_within_range, :missing_dates_within_range

      sig do
        params(
          id: Integer,
          payee: String,
          currency: String,
          created_by: Integer,
          created_at: String,
          updated_at: String,
          billing_date: String,
          source: String,
          amount: String,
          cadence: String,
          granularity: String,
          date: String,
          is_income: T::Boolean,
          exclude_from_totals: T::Boolean,
          start_date: T.nilable(String),
          end_date: T.nilable(String),
          original_name: T.nilable(String),
          description: T.nilable(String),
          notes: T.nilable(String),
          plaid_account_id: T.nilable(Integer),
          asset_id: T.nilable(Integer),
          category_id: T.nilable(Integer),
          category_group_id: T.nilable(Integer),
          quantity: T.nilable(Integer),
          to_base: T.nilable(Number),
          occurrences: T.nilable(T::Hash[String, T::Array[T.untyped]]),
          transactions_within_range: T.nilable(T::Array[T.untyped]),
          missing_dates_within_range: T.nilable(T::Array[T.untyped]),
        ).void
      end
      def initialize(id:, payee:, currency:, created_by:, created_at:, updated_at:, billing_date:, source:,
        amount:, cadence:, granularity:, date:, is_income:, exclude_from_totals:, start_date: nil,
        end_date: nil, original_name: nil, description: nil, notes: nil, plaid_account_id: nil,
        asset_id: nil, category_id: nil, category_group_id: nil, quantity: nil, to_base: nil,
        occurrences: nil, transactions_within_range: nil, missing_dates_within_range: nil)
        super()
        @id = id
        @payee = payee
        @currency = currency
        @created_by = created_by
        @created_at = created_at
        @updated_at = updated_at
        @billing_date = billing_date
        @source = source
        @amount = amount
        @cadence = cadence
        @granularity = granularity
        @date = date
        @is_income = is_income
        @exclude_from_totals = exclude_from_totals
        @start_date = start_date
        @end_date = end_date
        @original_name = original_name
        @description = description
        @notes = notes
        @plaid_account_id = plaid_account_id
        @asset_id = asset_id
        @category_id = category_id
        @category_group_id = category_group_id
        @quantity = quantity
        @to_base = to_base
        @occurrences = occurrences
        @transactions_within_range = transactions_within_range
        @missing_dates_within_range = missing_dates_within_range
      end
    end
  end
end
