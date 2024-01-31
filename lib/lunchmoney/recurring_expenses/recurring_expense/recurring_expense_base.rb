# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#recurring-expenses-object
  class RecurringExpenseBase < LunchMoney::DataObject
    sig { returns(String) }
    attr_accessor :payee, :currency, :amount

    sig { returns(T.nilable(Number)) }
    attr_accessor :to_base

    sig do
      params(
        payee: String,
        amount: String,
        currency: String,
        to_base: T.nilable(Number),
      ).void
    end
    def initialize(payee:, amount:, currency:, to_base:)
      super()
      @payee = payee
      @amount = amount
      @currency = currency
      @to_base = to_base
    end
  end
end
