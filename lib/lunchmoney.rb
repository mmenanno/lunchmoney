# frozen_string_literal: true

require "active_support/core_ext/module/delegation"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/module/attribute_accessors"
require "faraday"
require "faraday/multipart"
require "faraday/retry"

require_relative "lunchmoney/version"
require_relative "lunchmoney/errors"
require_relative "lunchmoney/configuration"
require_relative "lunchmoney/client/rate_limit"
require_relative "lunchmoney/client/base"

module LunchMoney
  LOCK = Mutex.new

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration ||= Configuration.new }
    end
  end
end
