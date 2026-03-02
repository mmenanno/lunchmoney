# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class SummaryTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      test "summary with aligned response returns AlignedSummaryResponse" do
        stub_lunchmoney(:get, "/summary?start_date=2025-07-01&end_date=2025-08-31",
          response: "summary/list_aligned_monthly")

        result = @api.summary(start_date: "2025-07-01", end_date: "2025-08-31")

        assert_kind_of LunchMoney::Objects::Summary::AlignedSummaryResponse, result
        assert result.aligned?
        assert_equal true, result.aligned
        assert_kind_of Array, result.categories
        assert_equal 3, result.categories.length
      end

      test "summary with non-aligned response returns NonAlignedSummaryResponse" do
        stub_lunchmoney(:get, "/summary?start_date=2025-07-01&end_date=2025-08-15",
          response: "summary/list_not_aligned")

        result = @api.summary(start_date: "2025-07-01", end_date: "2025-08-15")

        assert_kind_of LunchMoney::Objects::Summary::NonAlignedSummaryResponse, result
        refute result.aligned?
        assert_equal false, result.aligned
        assert_kind_of Array, result.categories
        assert_equal 7, result.categories.length
      end

      test "summary raises error on failure" do
        stub_lunchmoney_error(:get, "/summary?start_date=invalid&end_date=invalid",
          status: 400, message: "Invalid date range")

        error = assert_raises(LunchMoney::ValidationError) do
          @api.summary(start_date: "invalid", end_date: "invalid")
        end

        assert_equal "Invalid date range", error.message
        assert_equal 400, error.status_code
      end
    end
  end
end
