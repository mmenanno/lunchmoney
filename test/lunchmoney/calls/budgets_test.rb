# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class BudgetTest < ActiveSupport::TestCase
      include MockResponseHelper

      test "budgets returns an array of Budget objects on success response" do
        api_call = LunchMoney::Calls::Budgets.new.budgets(start_date: "2023-01-01", end_date: "2024-01-01")

        api_call.each do |budget|
          assert_kind_of(LunchMoney::Objects::Budget, budget)
        end
      end

      test "budgets returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Budgets.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Budgets.new.budgets(start_date: "2023-01-01", end_date: "2024-01-01")

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "upsert_budget does not return an error on success response" do
        api_call = LunchMoney::Calls::Budgets.new.upsert_budget(
          start_date: "2023-01-01",
          category_id: 777052,
          amount: 400.99,
        )

        refute_kind_of(LunchMoney::Errors, api_call)
      end

      test "upsert_budget returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Budgets.any_instance.stubs(:put).returns(response)

        api_call = LunchMoney::Calls::Budgets.new.upsert_budget(
          start_date: "2023-01-01",
          category_id: 777052,
          amount: 400.99,
        )

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "remove_budget returns a boolean on success response" do
        api_call = LunchMoney::Calls::Budgets.new.remove_budget(start_date: "2023-01-01", category_id: 777052)

        assert_includes([TrueClass, FalseClass], api_call.class)
      end

      test "remove_budget returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Budgets.any_instance.stubs(:delete).returns(response)

        api_call = LunchMoney::Calls::Budgets.new.remove_budget(start_date: "2023-01-01", category_id: 777052)

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
