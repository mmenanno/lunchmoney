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
  # class << self
  #   sig { returns(LunchMoney::Api) }
  #   def new
  #     LunchMoney::Api.new
  #   end

  #   def configuration
  #     @configuration = nil unless defined?(@configuration)
  #     @configuration ||= LunchMoney::Config.new
  #   end
  # end
end
