# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Split < LunchMoney::DataObject
    sig { returns(T.nilable(String)) }
    attr_accessor :payee, :date, :notes

    sig { returns(T.nilable(Integer)) }
    attr_accessor :category_id

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
      super()
      @amount = amount
      @payee = payee
      @date = date
      @category_id = category_id
      @notes = notes
    end
  end
end
