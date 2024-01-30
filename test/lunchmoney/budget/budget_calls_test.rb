# typed: strict
# frozen_string_literal: true

require "test_helper"

class BudgetCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include VcrHelper

  test "budgets returns an array of Budget objects on success response" do
    with_real_ci_connections do
      VCR.use_cassette("budget/budgets_success") do
        api_call = LunchMoney::BudgetCalls.new.budgets(start_date: "2023-01-01", end_date: "2024-01-01")

        assert_kind_of(LunchMoney::Budget, api_call.first)
      end
    end
  end

  test "budgets returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::BudgetCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::BudgetCalls.new.budgets(start_date: "2023-01-01", end_date: "2024-01-01")

    assert_kind_of(LunchMoney::Error, api_call.first)
  end

  test "upsert_budget does not return an error on success response" do
    VCR.use_cassette("budget/upsert_budget_success") do
      api_call = LunchMoney::BudgetCalls.new.upsert_budget(
        start_date: "2023-01-01",
        category_id: 777052,
        amount: 400.99,
      )

      api_call.each do |group|
        refute_kind_of(LunchMoney::Error, group)
      end
    end
  end

  test "upsert_budget returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::BudgetCalls.any_instance.stubs(:put).returns(response)

    api_call = LunchMoney::BudgetCalls.new.upsert_budget(
      start_date: "2023-01-01",
      category_id: 777052,
      amount: 400.99,
    )

    assert_kind_of(LunchMoney::Error, api_call.first)
  end
end
