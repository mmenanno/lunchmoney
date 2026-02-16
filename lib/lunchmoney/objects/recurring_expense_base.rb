# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#recurring-expenses-object
    class RecurringExpenseBase < LunchMoney::Objects::Object
      attr_accessor :payee, :currency, :amount

      attr_accessor :to_base

      def initialize(payee:, amount:, currency:, to_base:)
        super()
        @payee = payee
        @amount = amount
        @currency = currency
        @to_base = to_base
      end
    end
  end
end
