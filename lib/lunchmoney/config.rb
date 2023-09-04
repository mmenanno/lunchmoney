# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Config
    cattr_accessor(:token) { ENV.fetch("LUNCHMONEY_TOKEN", nil) }
  end
end
