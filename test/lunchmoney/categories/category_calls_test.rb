# typed: strict
# frozen_string_literal: true

require "test_helper"

class CategoryCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include FakeResponseDataHelper

  test "all_categories returns an array of Category objects on success response" do
    response = mock_faraday_response(fake_all_categories_response)

    LunchMoney::CategoryCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::CategoryCalls.new.all_categories

    assert_kind_of(LunchMoney::Category, api_call.first)
  end

  test "all_categories returns an array of Error objects on error response" do
    response = mock_faraday_response(fake_general_error)

    LunchMoney::CategoryCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::CategoryCalls.new.all_categories(format: "flattened")

    assert_kind_of(LunchMoney::Error, api_call.first)
  end

  test "all_categories does not raise an error when called with flattened format" do
    response = mock_faraday_response(fake_all_categories_response)

    query_params = { format: "flattened" }

    LunchMoney::CategoryCalls.any_instance.stubs(:get).with("categories", query_params:).returns(response)

    assert_nothing_raised do
      LunchMoney::CategoryCalls.new.all_categories(**query_params)
    end
  end

  test "all_categories does not raise an error when called with nested format" do
    response = mock_faraday_response(fake_all_categories_response)

    query_params = { format: "nested" }

    LunchMoney::CategoryCalls.any_instance.stubs(:get).with("categories", query_params:).returns(response)

    assert_nothing_raised do
      LunchMoney::CategoryCalls.new.all_categories(**query_params)
    end
  end

  test "all_categories raises an exception when called with invalid format" do
    response = mock_faraday_response(fake_all_categories_response)

    query_params = { format: "not_a_valid_format" }

    LunchMoney::CategoryCalls.any_instance.stubs(:get).with("categories", query_params:).returns(response)

    error = assert_raises(LunchMoney::InvalidQueryParameter) do
      LunchMoney::CategoryCalls.new.all_categories(**query_params)
    end

    assert_equal("format must be either flattened or nested", error.message)
  end
end
