# typed: strict
# frozen_string_literal: true

require "test_helper"

class CategoryCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include VcrHelper

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

    assert_kind_of(LunchMoney::Errors, api_call)
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

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end

  test "create_category returns an id of created category success response" do
    VCR.use_cassette("categories/create_category_success") do
      api_call = LunchMoney::CategoryCalls.new.create_category(name: "Create Category Test")
      api_call = T.cast(api_call, T::Hash[Symbol, Integer])

      assert_kind_of(Integer, api_call[:category_id])
    end
  end

  test "create_category returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CategoryCalls.any_instance.stubs(:post).returns(response)

    api_call = LunchMoney::CategoryCalls.new.create_category(name: "Create Category Test")

    assert_kind_of(LunchMoney::Errors, api_call)
  end

  test "create_category_group returns anid of created category group on success response" do
    VCR.use_cassette("categories/create_category_group_success") do
      api_call = LunchMoney::CategoryCalls.new.create_category_group(name: "Create Category Group Test")
      api_call = T.cast(api_call, T::Hash[Symbol, Integer])

      assert_kind_of(Integer, api_call[:category_id])
    end
  end

  test "create_category_group returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CategoryCalls.any_instance.stubs(:post).returns(response)

    api_call = LunchMoney::CategoryCalls.new.create_category_group(name: "Create Category Group Test")

    assert_kind_of(LunchMoney::Errors, api_call)
  end

  test "update_category returns a boolean on success response" do
    VCR.use_cassette("categories/update_category_success") do
      api_call = LunchMoney::CategoryCalls.new.update_category(784587, name: "Update Category Test")

      assert_includes([TrueClass, FalseClass], api_call.class)
    end
  end

  test "update_category returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CategoryCalls.any_instance.stubs(:put).returns(response)

    api_call = LunchMoney::CategoryCalls.new.update_category(784587, name: "Update Category Test")

    assert_kind_of(LunchMoney::Errors, api_call)
  end

  test "add_to_category_group returns a Category object on success response" do
    VCR.use_cassette("categories/add_to_category_group_success") do
      api_call = LunchMoney::CategoryCalls.new.add_to_category_group(784588, new_categories: ["New Category Test"])

      assert_kind_of(LunchMoney::Category, api_call)
    end
  end

  test "add_to_category_group returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CategoryCalls.any_instance.stubs(:post).returns(response)

    api_call = LunchMoney::CategoryCalls.new.add_to_category_group(784588, new_categories: ["New Category Test"])

    assert_kind_of(LunchMoney::Errors, api_call)
  end

  test "delete_category returns a boolean on success response" do
    VCR.use_cassette("categories/delete_category_success") do
      api_call = LunchMoney::CategoryCalls.new.delete_category(784587)

      assert_includes([TrueClass, FalseClass], api_call.class)
    end
  end

  test "delete_category returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CategoryCalls.any_instance.stubs(:delete).returns(response)

    api_call = LunchMoney::CategoryCalls.new.delete_category(784587)

    assert_kind_of(LunchMoney::Errors, api_call)
  end

  test "force_delete_category returns a boolean on success response" do
    VCR.use_cassette("categories/force_delete_category_success") do
      api_call = LunchMoney::CategoryCalls.new.force_delete_category(784588)

      assert_includes([TrueClass, FalseClass], api_call.class)
    end
  end

  test "force_delete_category returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CategoryCalls.any_instance.stubs(:delete).returns(response)

    api_call = LunchMoney::CategoryCalls.new.force_delete_category(784588)

    assert_kind_of(LunchMoney::Errors, api_call)
  end
end
