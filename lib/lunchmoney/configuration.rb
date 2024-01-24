# typed: strict
# frozen_string_literal: true

module LunchMoney
  # Holds global configuration options for this gem
  # @example api_key
  #   LunchMoney::Configuration.api_key
  #   => "your_api_key"
  #
  # @example validate_object_attributes
  #   LunchMoney::Configuration.validate_object_attributes
  #   => true
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
