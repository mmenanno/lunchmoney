# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Configuration
    sig { returns(T.nilable(String)) }
    attr_accessor :api_key

    sig { returns(T::Boolean) }
    attr_accessor :validate_object_attributes

    sig { void }
    def initialize
      @api_key = ENV.fetch("LUNCHMONEY_TOKEN", nil)
      @validate_object_attributes = T.let(true, T::Boolean)
    end
  end
end
