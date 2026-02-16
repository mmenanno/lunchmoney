# frozen_string_literal: true

require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/module/attribute_accessors"
require "faraday"
require_relative "lunchmoney/version"
require_relative "lunchmoney/validators"
require_relative "lunchmoney/api"

module LunchMoney
  # Lock used to avoid config conflicts
  LOCK = Mutex.new

  class << self
    # @example Set your API key
    #   LunchMoney.configure do |config|
    #     config.api_key = "your_api_key"
    #   end
    #
    # @example Turn off object validation
    #   LunchMoney.configure do |config|
    #     config.validate_object_attributes = false
    #   end
    def configure(&block)
      yield(configuration)
    end

    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration = LunchMoney::Configuration.new }
    end

    def validate_object_attributes?
      configuration.validate_object_attributes
    end
  end
end
