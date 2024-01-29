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

    sig do
      params(
        start_date: T.nilable(String),
        end_date: T.nilable(String),
        plaid_account_id: T.nilable(Integer),
      ).returns(T.any(T::Boolean, LunchMoney::Errors))
    end
    def plaid_accounts_fetch(start_date: nil, end_date: nil, plaid_account_id: nil)
      params = clean_params({ start_date:, end_date:, plaid_account_id: })
      response = post("plaid_accounts/fetch", params)

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body
    end
  end
end
