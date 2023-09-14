# typed: strict
# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/module/delegation.rb"
require "faraday"
require "sorbet-runtime"

# Include T::Sig directly in the module class so that it doesn't need to be extended everywhere.
Module.include(T::Sig)

require_relative "lunchmoney/version"
require_relative "lunchmoney/api"

module LunchMoney
  LOCK = T.let(Mutex.new, Mutex)

  class << self
    sig do
      params(block: T.proc.params(arg0: LunchMoney::Config).void).void
    end
    def configure(&block)
      yield(configuration)
    end

    sig { returns(LunchMoney::Config) }
    def configuration
      @configuration = T.let(nil, T.nilable(LunchMoney::Config)) unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration = LunchMoney::Config.new }
    end
  end
end
