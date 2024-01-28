# typed: strict
# frozen_string_literal: true

require "test_helper"

class CategoryCallsTest < ActiveSupport::TestCase
  include MockResponseHelper

  test "categories returns an array of Category objects on success response" do
    VCR.use_cassette("categories/categories_success") do
      api_call = LunchMoney::CategoryCalls.new.categories

      assert_kind_of(LunchMoney::Category, api_call.first)
    end
  end

  test "categories returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CategoryCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::CategoryCalls.new.categories(format: "flattened")

    assert_kind_of(LunchMoney::Error, api_call.first)
  end

  test "categories does not raise an error when called with flattened format" do
    query_params = { format: "flattened" }

    VCR.use_cassette("categories/categories_flattened_success") do
      assert_nothing_raised do
        LunchMoney::CategoryCalls.new.categories(**query_params)
      end
    end
  end

  test "categories does not raise an error when called with nested format" do
    query_params = { format: "nested" }

    VCR.use_cassette("categories/categories_nested_success") do
      assert_nothing_raised do
        LunchMoney::CategoryCalls.new.categories(**query_params)
      end
    end
  end

  test "categories raises an exception when called with invalid format" do
    query_params = { format: "not_a_valid_format" }

    error = assert_raises(LunchMoney::InvalidQueryParameter) do
      LunchMoney::CategoryCalls.new.categories(**query_params)
    end

    assert_equal("format must be either flattened or nested", error.message)
  end
end
