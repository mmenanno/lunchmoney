# typed: strict
# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/module/delegation.rb"
require "active_support/core_ext/object/blank.rb"
require "faraday"
require "sorbet-runtime"

# Include T::Sig directly in the module class so that it doesn't need to be extended everywhere.
class Module
  include T::Sig
end

Number = T.type_alias { T.any(Integer, Float) }

require_relative "lunchmoney/version"
require_relative "lunchmoney/validators"
require_relative "lunchmoney/api"

module LunchMoney
  # Lock used to avoid config conflicts
  LOCK = T.let(Mutex.new, Mutex)

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
    sig do
      params(block: T.proc.params(arg0: LunchMoney::Configuration).void).void
    end
    def configure(&block)
      yield(configuration)
    end

    sig { returns(LunchMoney::Configuration) }
    def configuration
      @configuration = T.let(nil, T.nilable(LunchMoney::Configuration)) unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration = LunchMoney::Configuration.new }
    end

    sig { returns(T::Boolean) }
    def validate_object_attributes?
      configuration.validate_object_attributes
    end
  end
end
