# typed: strict
# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class RecurringExpensesTest < ActiveSupport::TestCase
      include MockResponseHelper
      include VcrHelper

      test "recurring_expenses returns an array of Tag objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("recurring_expenses/recurring_expenses_success") do
            api_call = LunchMoney::Calls::RecurringExpenses.new.recurring_expenses

            api_call.each do |recurring_expense|
              assert_kind_of(LunchMoney::RecurringExpense, recurring_expense)
            end
          end
        end
      end

      test "recurring_expenses returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::RecurringExpenses.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::RecurringExpenses.new.recurring_expenses

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
