# typed: strict
# frozen_string_literal: true

require "active_support"
require "faraday"
require "sorbet-runtime"

# Include T::Sig directly in the module class so that it doesn't need to be extended everywhere.
Module.include(T::Sig)

require_relative "lunchmoney/version"

require_relative "lunchmoney/api"
require_relative "lunchmoney/errors"
require_relative "lunchmoney/config"

require_relative "lunchmoney/objects/split"
require_relative "lunchmoney/objects/struct"
require_relative "lunchmoney/objects/transaction"
require_relative "lunchmoney/objects/category"
require_relative "lunchmoney/objects/recurring_expense"
require_relative "lunchmoney/objects/tag"
require_relative "lunchmoney/objects/data"
require_relative "lunchmoney/objects/budget"
require_relative "lunchmoney/objects/asset"
require_relative "lunchmoney/objects/plaid_account"
require_relative "lunchmoney/objects/crypto"

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
