# typed: strict
# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#config-object
    class Config < LunchMoney::Objects::Object
      # API object reference documentation: https://lunchmoney.dev/#config-object

      sig { returns(Integer) }
      attr_accessor :config_id

      sig { returns(Number) }
      attr_accessor :amount, :to_base

      sig { returns(String) }
      attr_accessor :cadence, :currency, :auto_suggest

      sig do
        params(
          config_id: Integer,
          cadence: String,
          amount: Number,
          currency: String,
          to_base: Number,
          auto_suggest: String,
        ).void
      end
      def initialize(config_id:, cadence:, amount:, currency:, to_base:, auto_suggest:)
        super()
        @config_id = config_id
        @cadence = cadence
        @amount = amount
        @currency = currency
        @to_base = to_base
        @auto_suggest = auto_suggest
      end
    end
  end
end
