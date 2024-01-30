# typed: strict
# frozen_string_literal: true

require "test_helper"

class RecurringExpenseCallsTest < ActiveSupport::TestCase
  include MockResponseHelper

  test "recurring_expenses returns an array of Tag objects on success response" do
    with_real_ci_connections do
      VCR.use_cassette("recurring_expenses/recurring_expenses_success") do
        api_call = LunchMoney::RecurringExpenseCalls.new.recurring_expenses

        api_call.each do |recurring_expense|
          assert_kind_of(LunchMoney::RecurringExpense, recurring_expense)
        end
      end
    end
  end

  test "recurring_expenses returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::RecurringExpenseCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::RecurringExpenseCalls.new.recurring_expenses

    api_call.each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end
end
