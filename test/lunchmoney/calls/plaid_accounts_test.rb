# typed: strict
# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class PlaidAccountsTest < ActiveSupport::TestCase
      include MockResponseHelper
      include VcrHelper

      test "plaid_accounts returns an array of PlaidAccount objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("plaid_accounts/plaid_accounts_success") do
            api_call = LunchMoney::Calls::PlaidAccounts.new.plaid_accounts

            api_call.each do |plaid_account|
              assert_kind_of(LunchMoney::PlaidAccount, plaid_account)
            end
          end
        end
      end

      test "plaid_accounts returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::PlaidAccounts.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::PlaidAccounts.new.plaid_accounts

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "plaid_accounts_fetch returns a boolean response on success" do
        with_real_ci_connections do
          VCR.use_cassette("plaid_accounts/plaid_accounts_fetch_success") do
            api_call = LunchMoney::Calls::PlaidAccounts.new.plaid_accounts_fetch

            assert_includes([TrueClass, FalseClass], api_call.class)
          end
        end
      end

      test "plaid_accounts_fetch returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::PlaidAccounts.any_instance.stubs(:post).returns(response)

        api_call = LunchMoney::Calls::PlaidAccounts.new.plaid_accounts_fetch

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
