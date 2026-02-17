# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class MeTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      test "me returns a User object" do
        stub_lunchmoney(:get, "/me", response: "me")

        result = @api.me

        assert_instance_of LunchMoney::Objects::User, result
      end

      test "me returns user with correct attributes" do
        stub_lunchmoney(:get, "/me", response: "me")

        user = @api.me

        assert_equal 18328, user.id
        assert_equal "User 1", user.name
        assert_equal "user-1@lunchmoney.dev", user.email
        assert_equal 18221, user.account_id
        assert_equal "\\U0001F3E0 Family budget", user.budget_name
        assert_equal "usd", user.primary_currency
        assert_equal "Side project dev key", user.api_key_label
      end

      test "me populates rate limit info after request" do
        stub_lunchmoney(:get, "/me", response: "me")

        assert_nil @api.rate_limit

        @api.me

        refute_nil @api.rate_limit
        assert_equal 100, @api.rate_limit.limit
        assert_equal 99, @api.rate_limit.remaining
      end

      test "me raises AuthenticationError on 401" do
        stub_lunchmoney_error(:get, "/me", status: 401, message: "Unauthorized")

        error = assert_raises(LunchMoney::AuthenticationError) { @api.me }

        assert_equal 401, error.status_code
        assert_equal "Unauthorized", error.message
      end
    end
  end
end
