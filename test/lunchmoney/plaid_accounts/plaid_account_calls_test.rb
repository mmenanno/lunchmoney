# typed: strict
# frozen_string_literal: true

require "test_helper"

class PlaidAccountCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include FakeResponseDataHelper

  test "plaid_accounts returns an array of PlaidAccount objects on success response" do
    response = mock_faraday_response(fake_plaid_accounts_call)
    LunchMoney::PlaidAccountCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::PlaidAccountCalls.new.plaid_accounts

    assert_kind_of(LunchMoney::PlaidAccount, api_call.first)
  end

  test "plaid_accounts returns an array of Error objects on error response" do
    response = mock_faraday_response(fake_general_error)
    LunchMoney::PlaidAccountCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::PlaidAccountCalls.new.plaid_accounts

    assert_kind_of(LunchMoney::Error, api_call.first)
  end

  test "plaid_accounts_fetch returns a boolean response on success" do
    VCR.use_cassette("plaid_accounts/plaid_accounts_fetch_success") do
      ensure_correct_api_key
      api_call = LunchMoney::PlaidAccountCalls.new.plaid_accounts_fetch

      assert_kind_of(FalseClass, api_call)
    end
  end

  test "plaid_accounts_fetch returns an array of Error objects on error response" do
    response = mock_faraday_response(fake_general_error)
    LunchMoney::PlaidAccountCalls.any_instance.stubs(:post).returns(response)

    api_call = LunchMoney::PlaidAccountCalls.new.plaid_accounts_fetch

    assert_kind_of(LunchMoney::Error, T.unsafe(api_call).first)
  end
end
