# frozen_string_literal: true

module LunchMoney
  module Objects
    # Slimmed down version of https://lunchmoney.dev/#transaction-object used as a base for other transaction objects
    class TransactionBase < LunchMoney::Objects::Object
      attr_accessor :id

      attr_accessor :to_base

      attr_accessor :asset_id, :plaid_account_id

      attr_accessor :date,
        :amount,
        :currency,
        :payee

      attr_accessor :notes

      def initialize(id:, date:, amount:, currency:, to_base:, payee:, notes: nil, asset_id: nil,
        plaid_account_id: nil)
        super()
        @id = id
        @date = date
        @amount = amount
        @currency = currency
        @to_base = to_base
        @payee = payee
        @notes = notes
        @asset_id = asset_id
        @plaid_account_id = plaid_account_id
      end
    end
  end
end
