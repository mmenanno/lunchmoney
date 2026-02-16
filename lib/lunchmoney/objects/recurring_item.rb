# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#recurring-items-object
    class RecurringItem < LunchMoney::Objects::Object
      attr_accessor :id, :created_by

      attr_accessor :payee, :currency, :created_at, :updated_at, :billing_date, :source, :amount, :cadence, :granularity, :date

      attr_accessor :start_date, :end_date, :original_name, :description, :notes

      attr_accessor :plaid_account_id, :asset_id, :category_id, :category_group_id, :quantity

      attr_accessor :to_base

      attr_accessor :is_income, :exclude_from_totals

      attr_accessor :occurrences

      attr_accessor :transactions_within_range, :missing_dates_within_range

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
