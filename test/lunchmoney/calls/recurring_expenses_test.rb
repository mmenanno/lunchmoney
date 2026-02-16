# typed: strict
# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class RecurringExpensesTest < ActiveSupport::TestCase
      include MockResponseHelper

      test "recurring_expenses returns an array of Tag objects on success response" do
        api_call = LunchMoney::Calls::RecurringExpenses.new.recurring_expenses

        api_call.each do |recurring_expense|
          assert_kind_of(LunchMoney::Objects::RecurringExpense, recurring_expense)
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
