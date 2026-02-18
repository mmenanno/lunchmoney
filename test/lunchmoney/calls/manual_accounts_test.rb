# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class ManualAccountsTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      test "manual_accounts returns array of ManualAccount objects" do
        stub_lunchmoney(:get, "/manual_accounts", response: "manual_accounts/list")

        result = @api.manual_accounts

        assert_kind_of Array, result
        assert_equal 2, result.length
        assert_kind_of LunchMoney::Objects::ManualAccount, result.first
        assert_equal 119807, result.first.id
        assert_equal "Individual Brokerage", result.first.name
        assert_equal "investment", result.first.type
        assert_kind_of LunchMoney::Objects::ManualAccount, result.last
        assert_equal 119909, result.last.id
        assert_equal "Euro Travel Card", result.last.name
      end

      test "manual_account returns single ManualAccount" do
        stub_lunchmoney(:get, "/manual_accounts/119807", response: "manual_accounts/get")

        result = @api.manual_account(119807)

        assert_kind_of LunchMoney::Objects::ManualAccount, result
        assert_equal 119807, result.id
        assert_equal "Individual Brokerage", result.name
        assert_equal "Fidelity", result.institution_name
        assert_equal "investment", result.type
        assert_equal "brokerage", result.subtype
        assert_equal "41211.8000", result.balance
        assert_equal "usd", result.currency
      end

      test "manual_account raises NotFoundError on 404" do
        stub_lunchmoney_error(:get, "/manual_accounts/999999", status: 404, message: "Not found")

        assert_raises(LunchMoney::NotFoundError) do
          @api.manual_account(999999)
        end
      end

      test "create_manual_account returns created ManualAccount" do
        stub_lunchmoney(:post, "/manual_accounts", response: "manual_accounts/create_minimum_request_response")

        result = @api.create_manual_account(name: "API created Account", type: "cash", balance: "100")

        assert_kind_of LunchMoney::Objects::ManualAccount, result
        assert_equal 119999, result.id
        assert_equal "API created Account", result.name
        assert_equal "cash", result.type
        assert_equal "100", result.balance
      end

      test "create_manual_account raises ClientValidationError for missing name" do
        error = assert_raises(LunchMoney::ClientValidationError) do
          @api.create_manual_account(type: "cash", balance: "100")
        end

        assert_equal "name is required", error.message
      end

      test "create_manual_account raises ClientValidationError for missing type" do
        error = assert_raises(LunchMoney::ClientValidationError) do
          @api.create_manual_account(name: "Test", balance: "100")
        end

        assert_equal "type is required", error.message
      end

      test "create_manual_account raises ClientValidationError for missing balance" do
        error = assert_raises(LunchMoney::ClientValidationError) do
          @api.create_manual_account(name: "Test", type: "cash")
        end

        assert_equal "balance is required", error.message
      end

      test "update_manual_account returns updated ManualAccount" do
        stub_lunchmoney(:put, "/manual_accounts/119807", response: "manual_accounts/update_type_changed_to_credit")

        result = @api.update_manual_account(119807, type: "credit")

        assert_kind_of LunchMoney::Objects::ManualAccount, result
        assert_equal 119807, result.id
        assert_equal "Individual Brokerage", result.name
      end

      test "delete_manual_account returns nil" do
        stub_lunchmoney(:delete, "/manual_accounts/119807", status: 204)

        result = @api.delete_manual_account(119807)

        assert_nil result
      end
    end
  end
end
