# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#summarized-transaction-object
    class SummarizedTransaction < LunchMoney::Objects::Object
      attr_accessor :id, :category_id, :recurring_id

      attr_accessor :date, :amount, :currency, :payee

      attr_accessor :to_base

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
