# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class RecurringItemsTest < ActiveSupport::TestCase
      include MockResponseHelper
      include VcrHelper

      test "recurring_items returns an array of RecurringItem objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("recurring_items/recurring_items_success") do
            api_call = LunchMoney::Calls::RecurringItems.new.recurring_items

            api_call.each do |recurring_item|
              assert_kind_of(LunchMoney::Objects::RecurringItem, recurring_item)
            end
          end
        end
      end

      test "recurring_items returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::RecurringItems.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::RecurringItems.new.recurring_items

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "recurring_items accepts start_date and end_date parameters" do
        with_real_ci_connections do
          VCR.use_cassette("recurring_items/recurring_items_with_dates_success") do
            api_call = LunchMoney::Calls::RecurringItems.new.recurring_items(
              start_date: "2024-01-01",
              end_date: "2024-12-31",
            )

            api_call.each do |recurring_item|
              assert_kind_of(LunchMoney::Objects::RecurringItem, recurring_item)
            end
          end
        end
      end
    end
  end
end
