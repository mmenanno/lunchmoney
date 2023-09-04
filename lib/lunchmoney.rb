# typed: strict
# frozen_string_literal: true

require "pry"
require "lunchmoney/api"
require "lunchmoney/errors"
require "lunchmoney/config"

require "lunchmoney/objects/split"
require "lunchmoney/objects/struct"
require "lunchmoney/objects/transaction"
require "lunchmoney/objects/category"
require "lunchmoney/objects/recurring_expense"
require "lunchmoney/objects/tag"
require "lunchmoney/objects/data"
require "lunchmoney/objects/budget"
require "lunchmoney/objects/asset"
require "lunchmoney/objects/plaid_account"
require "lunchmoney/objects/crypto"

# Include T::Sig directly in the module class so that it doesn't need to be extended everywhere.
Module.include(T::Sig)

module LunchMoney
  class << self
    sig { returns(LunchMoney::Api) }
    def new
      LunchMoney::Api.new
    end

    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration ||= LunchMoney::Config.new
    end
  end
end

binding.pry
