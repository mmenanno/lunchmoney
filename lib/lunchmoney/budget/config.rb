# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Config < LunchMoney::DataObject
    sig { returns(Integer) }
    attr_accessor :config_id, :amount, :to_base

    sig { returns(String) }
    attr_accessor :cadence, :currency, :auto_suggest

    sig do
      params(
        config_id: Integer,
        cadence: String,
        amount: Integer,
        currency: String,
        to_base: Integer,
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
