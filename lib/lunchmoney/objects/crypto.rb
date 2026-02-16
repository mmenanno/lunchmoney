# frozen_string_literal: true

require_relative "crypto_base"
module LunchMoney
  module Objects
    # https://lunchmoney.dev/#crypto-object
    class Crypto < CryptoBase
      include LunchMoney::Validators

      attr_reader :balance_as_of

      attr_accessor :currency, :status

      attr_accessor :to_base

      def initialize(created_at:, source:, name:, balance:, balance_as_of:, currency:,
        status:, institution_name: nil, id: nil, zabo_account_id: nil, display_name: nil, to_base: nil)
        super(created_at:, source:, name:, balance:, institution_name:, id:, zabo_account_id:, display_name:)
        @balance_as_of = validate_iso8601!(balance_as_of)
        @currency = currency
        @status = status
        @to_base = to_base
      end

      def balance_as_of=(time)
        @balance_as_of = validate_iso8601!(time)
      end
    end
  end
end
