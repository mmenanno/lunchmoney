# typed: strict
# frozen_string_literal: true

require_relative "plaid_account"

module LunchMoney
  class PlaidAccountCalls < ApiCall
    sig { returns(T::Array[LunchMoney::PlaidAccount]) }
    def plaid_accounts
      response = get("plaid_accounts")

      errors(response)

      response.body[:plaid_accounts].map do |plaid_account|
        LunchMoney::PlaidAccount.new(plaid_account)
      end
    end
  end
end
