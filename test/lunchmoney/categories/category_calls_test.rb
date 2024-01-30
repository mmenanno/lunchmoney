# typed: strict
# frozen_string_literal: true

require "test_helper"

class CategoryCallsTest < ActiveSupport::TestCase
  include MockResponseHelper

  test "categories returns an array of Category objects on success response" do
    with_real_ci_connections do
      VCR.use_cassette("categories/categories_success") do
        api_call = LunchMoney::CategoryCalls.new.categories

        api_call.each do |category|
          assert_kind_of(LunchMoney::Category, category)
        end
      end
    end
  end

  test "categories returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CategoryCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::CategoryCalls.new.categories(format: "flattened")

    api_call.each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  test "categories does not raise an error when called with flattened format" do
    with_real_ci_connections do
      query_params = { format: "flattened" }

      VCR.use_cassette("categories/categories_flattened_success") do
        assert_nothing_raised do
          LunchMoney::CategoryCalls.new.categories(**query_params)
        end
      end
    end
  end

  test "categories does not raise an error when called with nested format" do
    with_real_ci_connections do
      query_params = { format: "nested" }

      VCR.use_cassette("categories/categories_nested_success") do
        assert_nothing_raised do
          LunchMoney::CategoryCalls.new.categories(**query_params)
        end
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

  test "category returns a Category object on success response with regular category" do
    with_real_ci_connections do
      VCR.use_cassette("categories/category_category_success") do
        api_call = LunchMoney::CategoryCalls.new.category(777052)

        assert_kind_of(LunchMoney::Category, api_call)
      end
    end
  end

  test "category returns a Category object on success response with category group" do
    with_real_ci_connections do
      VCR.use_cassette("categories/category_category_group_success") do
        api_call = LunchMoney::CategoryCalls.new.category(777021)

        assert_kind_of(LunchMoney::Category, api_call)
      end
    end
  end

  test "category returns an array of Error objects on error response" do
    with_real_ci_connections do
      VCR.use_cassette("categories/category_does_not_exist_failure") do
        api_call = LunchMoney::CategoryCalls.new.category(1)

        T.unsafe(api_call).each do |error|
          assert_kind_of(LunchMoney::Error, error)
        end
      end
    end
  end
end
