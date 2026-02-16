# frozen_string_literal: true

require_relative "transaction_base"

module LunchMoney
  module Objects
    # Slimmed down version of https://lunchmoney.dev/#transaction-object used in the
    # `children` field of a transaction object with an additional `formatted_date`` field
    class ChildTransaction < TransactionBase
      attr_accessor :formatted_date

      def initialize(id:, date:, amount:, currency:, to_base:, payee:, formatted_date:, notes: nil, asset_id: nil,
        plaid_account_id: nil)
        super(id:, date:, amount:, currency:, to_base:, payee:, notes:, asset_id:, plaid_account_id:)
        @formatted_date = formatted_date
      end
    end
  end
end
