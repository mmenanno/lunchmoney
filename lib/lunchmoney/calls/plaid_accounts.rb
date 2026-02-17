# frozen_string_literal: true

module LunchMoney
  module Calls
    module PlaidAccounts
      include Base

      # List all Plaid-connected accounts.
      #
      # @return [Array<LunchMoney::Objects::PlaidAccount>]
      def plaid_accounts
        data = get("/plaid_accounts")
        build_collection(Objects::PlaidAccount, data, key: :plaid_accounts)
      end

      # Get a single Plaid account by ID.
      #
      # @param id [Integer]
      # @return [LunchMoney::Objects::PlaidAccount]
      # @raise [LunchMoney::NotFoundError]
      def plaid_account(id)
        data = get("/plaid_accounts/#{id}")
        build_object(Objects::PlaidAccount, data)
      end

      # Trigger a fetch of latest data from Plaid.
      #
      # @param start_date [String, nil] ISO 8601 date
      # @param end_date [String, nil] ISO 8601 date
      # @param plaid_account_id [Integer, nil] specific account to fetch
      # @return [Array<LunchMoney::Objects::PlaidAccount>] the fetched accounts
      def plaid_accounts_fetch(start_date: nil, end_date: nil, plaid_account_id: nil)
        body = { start_date:, end_date:, plaid_account_id: }.compact
        data = post("/plaid_accounts/fetch", body: body)
        build_collection(Objects::PlaidAccount, data, key: :plaid_accounts)
      end
    end
  end
end
