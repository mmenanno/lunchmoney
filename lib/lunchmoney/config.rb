# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Config
    sig { returns(T.nilable(String)) }
    attr_accessor :api_key

    sig { void }
    def initialize
      @api_key = ENV.fetch("LUNCHMONEY_TOKEN", nil)
    end
  end
end
