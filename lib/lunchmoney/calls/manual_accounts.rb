# frozen_string_literal: true

module LunchMoney
  module Calls
    module ManualAccounts
      include Base

      # List all manual accounts.
      #
      # @return [Array<LunchMoney::Objects::ManualAccount>]
      def manual_accounts
        data = get("/manual_accounts")
        build_collection(Objects::ManualAccount, data, key: :manual_accounts)
      end

      # Get a single manual account by ID.
      #
      # @param id [Integer]
      # @return [LunchMoney::Objects::ManualAccount]
      # @raise [LunchMoney::NotFoundError]
      def manual_account(id)
        data = get("/manual_accounts/#{id}")
        build_object(Objects::ManualAccount, data)
      end

      # Create a manual account.
      #
      # @param attrs [Hash] account attributes (name:, type:, balance:, subtype:,
      #   currency:, institution_name:, exclude_from_transactions:, etc.)
      # @return [LunchMoney::Objects::ManualAccount]
      def create_manual_account(**attrs)
        account = Objects::CreateManualAccount.new(**attrs)
        account.validate!
        data = post("/manual_accounts", body: account.serialize)
        build_object(Objects::ManualAccount, data)
      end

      # Update a manual account.
      #
      # @param id [Integer]
      # @param attrs [Hash] attributes to update
      # @return [LunchMoney::Objects::ManualAccount]
      def update_manual_account(id, **attrs)
        account = Objects::UpdateManualAccount.new(**attrs)
        account.validate!
        data = put("/manual_accounts/#{id}", body: account.serialize)
        build_object(Objects::ManualAccount, data)
      end

      # Delete a manual account.
      #
      # @param id [Integer]
      # @return [nil]
      def delete_manual_account(id)
        delete("/manual_accounts/#{id}")
      end
    end
  end
end
