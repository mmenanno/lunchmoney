# frozen_string_literal: true

require_relative "transaction_modification_base"

module LunchMoney
  module Objects
    # Object used to split a transaction when updating https://lunchmoney.dev/#update-transaction
    class Split < TransactionModificationBase
      attr_accessor :amount

      def initialize(amount:, payee: nil, date: nil, category_id: nil, notes: nil)
        super(payee:, date:, category_id:, notes:)
        @amount = amount
      end
    end
  end
end
