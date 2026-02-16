# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#config-object
    class Config < LunchMoney::Objects::Object
      # API object reference documentation: https://lunchmoney.dev/#config-object

      attr_accessor :config_id

      attr_accessor :amount, :to_base

      attr_accessor :cadence, :currency, :auto_suggest

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
