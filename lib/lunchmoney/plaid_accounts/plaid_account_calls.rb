# typed: strict
# frozen_string_literal: true

require_relative "plaid_account"

module LunchMoney
  # https://lunchmoney.dev/#plaid-accounts
  class PlaidAccountCalls < ApiCall
    sig { returns(T.any(T::Array[LunchMoney::PlaidAccount], LunchMoney::Errors)) }
    def plaid_accounts
      response = get("plaid_accounts")

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body[:plaid_accounts].map do |plaid_account|
        LunchMoney::PlaidAccount.new(**plaid_account)
      end
    end
  end
end
