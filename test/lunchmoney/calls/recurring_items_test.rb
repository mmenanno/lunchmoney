# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class RecurringItemsTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      test "recurring_items returns array of RecurringItem objects" do
        stub_lunchmoney(:get, "/recurring_items?start_date=2024-10-01&end_date=2024-10-31",
          response: "recurring_items/list")

        result = @api.recurring_items(start_date: "2024-10-01", end_date: "2024-10-31")

        assert_kind_of Array, result
        assert_equal 2, result.length
        assert_kind_of LunchMoney::Objects::RecurringItem, result.first
        assert_equal 994069, result.first.id
        assert_equal "Income", result.first.description
        assert_kind_of LunchMoney::Objects::RecurringItem, result.last
        assert_equal 994079, result.last.id
        assert_equal "Monthly rent payable to Mrs Smith", result.last.description
      end

      test "recurring_item returns single RecurringItem" do
        stub_lunchmoney(:get, "/recurring_items/994069?start_date=2024-10-01&end_date=2024-10-31",
          response: "recurring_items/get")

        result = @api.recurring_item(994069, start_date: "2024-10-01", end_date: "2024-10-31")

        assert_kind_of LunchMoney::Objects::RecurringItem, result
        assert_equal 994069, result.id
        assert_equal "Income", result.description
        assert_equal "reviewed", result.status
        assert_equal "manual", result.source
        assert_kind_of Hash, result.transaction_criteria
        assert_kind_of Hash, result.overrides
        assert_kind_of Hash, result.matches
      end

      test "recurring_item raises NotFoundError on 404" do
        stub_lunchmoney_error(:get, "/recurring_items/999999?start_date=2024-10-01&end_date=2024-10-31",
          status: 404, message: "Not found")

        assert_raises(LunchMoney::NotFoundError) do
          @api.recurring_item(999999, start_date: "2024-10-01", end_date: "2024-10-31")
        end
      end
    end
  end
end
