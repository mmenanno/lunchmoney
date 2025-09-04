# typed: strict
# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#summarized-transaction-object
    class SummarizedTransaction < LunchMoney::Objects::Object
      sig { returns(Integer) }
      attr_accessor :id, :category_id, :recurring_id

      sig { returns(String) }
      attr_accessor :date, :amount, :currency, :payee

      sig { returns(T.nilable(Number)) }
      attr_accessor :to_base

      sig do
        params(
          id: Integer,
          date: String,
          amount: String,
          currency: String,
          payee: String,
          category_id: Integer,
          recurring_id: Integer,
          to_base: T.nilable(Number),
        ).void
      end
      def initialize(id:, date:, amount:, currency:, payee:, category_id:, recurring_id:, to_base: nil)
        super()
        @id = id
        @date = date
        @amount = amount
        @currency = currency
        @payee = payee
        @category_id = category_id
        @recurring_id = recurring_id
        @to_base = to_base
      end
    end
  end
end
