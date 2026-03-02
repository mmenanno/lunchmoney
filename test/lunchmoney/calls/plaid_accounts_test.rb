# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class PlaidAccountsTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      test "plaid_accounts returns array of PlaidAccount objects" do
        stub_lunchmoney(:get, "/plaid_accounts", response: "plaid_accounts/list")

        result = @api.plaid_accounts

        assert_kind_of Array, result
        assert_equal 3, result.length
        assert_kind_of LunchMoney::Objects::PlaidAccount, result.first
        assert_equal 119804, result.first.id
        assert_equal "401k", result.first.name
        assert_equal "Vanguard", result.first.institution_name
        assert_equal "brokerage", result.first.type
        assert_kind_of LunchMoney::Objects::PlaidAccount, result.last
        assert_equal 119807, result.last.id
        assert_equal "Checking", result.last.name
      end

      test "plaid_account returns single PlaidAccount" do
        stub_lunchmoney(:get, "/plaid_accounts/119805", response: "plaid_accounts/get")

        result = @api.plaid_account(119805)

        assert_kind_of LunchMoney::Objects::PlaidAccount, result
        assert_equal 119805, result.id
        assert_equal "Freedom", result.name
        assert_equal "Penny's Visa", result.display_name
        assert_equal "Chase", result.institution_name
        assert_equal "credit", result.type
        assert_equal "credit card", result.subtype
        assert_equal "1973", result.mask
        assert_equal "active", result.status
      end

      test "plaid_account raises NotFoundError on 404" do
        stub_lunchmoney_error(:get, "/plaid_accounts/999999", status: 404, message: "Not found")

        assert_raises(LunchMoney::NotFoundError) do
          @api.plaid_account(999999)
        end
      end

      test "plaid_accounts_fetch returns array of PlaidAccount objects" do
        stub_lunchmoney(:post, "/plaid_accounts/fetch", response: "plaid_accounts/list")

        result = @api.plaid_accounts_fetch(start_date: "2025-01-01", end_date: "2025-01-31")

        assert_kind_of Array, result
        assert_equal 3, result.length
        assert_kind_of LunchMoney::Objects::PlaidAccount, result.first
        assert_equal 119804, result.first.id
      end
    end
  end
end
