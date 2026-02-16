# frozen_string_literal: true

module LunchMoney
  module Objects
    # Base object used for transaction objects that are used to update
    # transactions https://lunchmoney.dev/#update-transaction
    class TransactionModificationBase < LunchMoney::Objects::Object
      attr_accessor :payee, :date, :notes

      attr_accessor :category_id

      def initialize(payee: nil, date: nil, category_id: nil, notes: nil)
        super()
        @payee = payee
        @date = date
        @category_id = category_id
        @notes = notes
      end
    end
  end
end
