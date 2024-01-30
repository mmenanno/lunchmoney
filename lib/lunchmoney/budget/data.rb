# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#data-object
  class Data < LunchMoney::DataObject
    # API object reference documentation: https://lunchmoney.dev/#data-object

    sig { returns(T.nilable(Integer)) }
    attr_accessor :num_transactions

    sig { returns(T.nilable(T.any(Integer, Float))) }
    attr_accessor :budget_amount, :budget_to_base, :spending_to_base

    sig { returns(T.nilable(String)) }
    attr_accessor :budget_currency

    sig { returns(T.nilable(T::Boolean)) }
    attr_accessor :is_automated

    sig do
      params(
        spending_to_base: T.nilable(T.any(Integer, Float)),
        num_transactions: T.nilable(Integer),
        budget_amount: T.nilable(T.any(Integer, Float)),
        budget_currency: T.nilable(String),
        budget_to_base: T.nilable(T.any(Integer, Float)),
        is_automated: T.nilable(T::Boolean),
      ).void
    end
    def initialize(spending_to_base: nil, num_transactions: nil, budget_amount: nil, budget_currency: nil,
      budget_to_base: nil, is_automated: nil)
      super()
      @budget_amount = budget_amount
      @budget_currency = budget_currency
      @budget_to_base = budget_to_base
      @spending_to_base = spending_to_base
      @num_transactions = num_transactions
      @is_automated = is_automated
    end
  end
end
