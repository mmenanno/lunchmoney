# typed: strict
# frozen_string_literal: true

module LunchMoney
  # Object used to split a transaction when updating https://lunchmoney.dev/#update-transaction
  class Split < TransactionModificationBase
    sig { returns(T.any(Integer, String)) }
    attr_accessor :amount

    sig do
      params(
        amount: T.any(Integer, String),
        payee: T.nilable(String),
        date: T.nilable(String),
        category_id: T.nilable(Integer),
        notes: T.nilable(String),
      ).void
    end
    def initialize(amount:, payee: nil, date: nil, category_id: nil, notes: nil)
      super(payee:, date:, category_id:, notes:)
      @amount = amount
    end
  end
end
