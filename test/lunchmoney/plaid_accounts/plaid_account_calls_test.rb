# typed: strict
# frozen_string_literal: true

require "test_helper"

class PlaidAccountCallsTest < ActiveSupport::TestCase
  include MockResponseHelper

  test "plaid_accounts returns an array of PlaidAccount objects on success response" do
    VCR.use_cassette("plaid_accounts/plaid_accounts_success") do
      api_call = LunchMoney::PlaidAccountCalls.new.plaid_accounts

      api_call.each do |plaid_account|
        assert_kind_of(LunchMoney::PlaidAccount, plaid_account)
      end
    end
  end

  test "plaid_accounts returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::PlaidAccountCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::PlaidAccountCalls.new.plaid_accounts

    api_call.each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  test "plaid_accounts_fetch returns a boolean response on success" do
    VCR.use_cassette("plaid_accounts/plaid_accounts_fetch_success") do
      api_call = LunchMoney::PlaidAccountCalls.new.plaid_accounts_fetch

      assert_kind_of(FalseClass, api_call)
    end
  end

  test "plaid_accounts_fetch returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::PlaidAccountCalls.any_instance.stubs(:post).returns(response)

    api_call = LunchMoney::PlaidAccountCalls.new.plaid_accounts_fetch

    T.unsafe(api_call).each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end
end
