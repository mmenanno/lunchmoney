# typed: strict
# frozen_string_literal: true

require_relative "../objects/plaid_account"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#plaid-accounts
    class PlaidAccounts < LunchMoney::Calls::Base
      sig { returns(T.any(T::Array[LunchMoney::Objects::PlaidAccount], LunchMoney::Errors)) }
      def plaid_accounts
        response = get("plaid_accounts")

        handle_api_response(response) do |body|
          body[:plaid_accounts].map do |plaid_account|
            LunchMoney::Objects::PlaidAccount.new(**plaid_account)
          end
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

        handle_api_response(response) do |body|
          body
        end
      end
    end
  end
end
