# typed: strict
# frozen_string_literal: true

module LunchMoney
  # Base object used for transaction objects that are used to update
  # transactions https://lunchmoney.dev/#update-transaction
  class TransactionModificationBase < LunchMoney::DataObject
    sig { returns(T.nilable(String)) }
    attr_accessor :payee, :date, :notes

    sig { returns(T.nilable(Integer)) }
    attr_accessor :category_id

    sig do
      params(
        payee: T.nilable(String),
        date: T.nilable(String),
        category_id: T.nilable(Integer),
        notes: T.nilable(String),
      ).void
    end
    def initialize(payee: nil, date: nil, category_id: nil, notes: nil)
      super()
      @payee = payee
      @date = date
      @category_id = category_id
      @notes = notes
    end
  end
end
