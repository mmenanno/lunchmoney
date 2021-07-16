# typed: strict
# frozen_string_literal: true

module LunchMoney
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
end
