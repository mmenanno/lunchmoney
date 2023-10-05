# typed: strict
# frozen_string_literal: true

require "test_helper"

class BudgetCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include FakeResponseDataHelper

  test "assets returns an array of Asset objects on success response" do
    response = mock_faraday_response(fake_budget_summary_response)

    LunchMoney::BudgetCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::BudgetCalls.new.budget_summary(start_date: "", end_date: "")

    assert_kind_of(LunchMoney::Budget, api_call.first)
  end

  test "assets returns an array of Error objects on error response" do
    response = mock_faraday_response(fake_general_error)

    LunchMoney::BudgetCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::BudgetCalls.new.budget_summary(start_date: "", end_date: "")

    assert_kind_of(LunchMoney::Error, api_call.first)
  end
end
