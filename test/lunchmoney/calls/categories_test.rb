# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class CategoriesTest < ActiveSupport::TestCase
      include MockResponseHelper

      test "categories returns an array of Category objects on success response" do
        api_call = LunchMoney::Calls::Categories.new.categories

        api_call.each do |category|
          assert_kind_of(LunchMoney::Objects::Category, category)
        end
      end

      test "categories returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Categories.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Categories.new.categories(format: "flattened")

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "categories does not raise an error when called with flattened format" do
        query_params = { format: "flattened" }

        assert_nothing_raised do
          LunchMoney::Calls::Categories.new.categories(**query_params)
        end
      end

      test "categories does not raise an error when called with nested format" do
        query_params = { format: "nested" }

        assert_nothing_raised do
          LunchMoney::Calls::Categories.new.categories(**query_params)
        end
      end

      test "categories raises an exception when called with invalid format" do
        query_params = { format: "not_a_valid_format" }

        error = assert_raises(LunchMoney::InvalidQueryParameter) do
          LunchMoney::Calls::Categories.new.categories(**query_params)
        end

        assert_equal("format must be either flattened or nested", error.message)
      end

      test "category returns a Category object on success response with regular category" do
        api_call = LunchMoney::Calls::Categories.new.category(777052)

        assert_kind_of(LunchMoney::Objects::Category, api_call)
      end

      test "category returns a Category object on success response with category group" do
        api_call = LunchMoney::Calls::Categories.new.category(777021)

        assert_kind_of(LunchMoney::Objects::Category, api_call)
      end

      test "category returns an array of Error objects on error response" do
        api_call = LunchMoney::Calls::Categories.new.category(1)

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "create_category returns an id of created category success response" do
        api_call = LunchMoney::Calls::Categories.new.create_category(name: "Create Category Test")

        assert_kind_of(Integer, api_call[:category_id])
      end

      test "create_category returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Categories.any_instance.stubs(:post).returns(response)

        api_call = LunchMoney::Calls::Categories.new.create_category(name: "Create Category Test")

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "create_category_group returns anid of created category group on success response" do
        api_call = LunchMoney::Calls::Categories.new.create_category_group(name: "Create Category Group Test")

        assert_kind_of(Integer, api_call[:category_id])
      end

      test "create_category_group returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Categories.any_instance.stubs(:post).returns(response)

        api_call = LunchMoney::Calls::Categories.new.create_category_group(name: "Create Category Group Test")

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "update_category returns a boolean on success response" do
        api_call = LunchMoney::Calls::Categories.new.update_category(1445992, name: "Update Category Test")

        assert_includes([TrueClass, FalseClass], api_call.class)
      end

      test "update_category returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Categories.any_instance.stubs(:put).returns(response)

        api_call = LunchMoney::Calls::Categories.new.update_category(784587, name: "Update Category Test")

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "add_to_category_group returns a Category object on success response" do
        api_call = LunchMoney::Calls::Categories.new.add_to_category_group(
          1445993,
          new_categories: ["New Category Test"],
        )

        assert_kind_of(LunchMoney::Objects::Category, api_call)
      end

      test "add_to_category_group returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Categories.any_instance.stubs(:post).returns(response)

        api_call = LunchMoney::Calls::Categories.new.add_to_category_group(
          1445993,
          new_categories: ["New Category Test"],
        )

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "delete_category returns a boolean on success response" do
        api_call = LunchMoney::Calls::Categories.new.delete_category(1445992)

        assert_includes([TrueClass, FalseClass], api_call.class)
      end

      test "delete_category returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Categories.any_instance.stubs(:delete).returns(response)

        api_call = LunchMoney::Calls::Categories.new.delete_category(784587)

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "force_delete_category returns a boolean on success response" do
        api_call = LunchMoney::Calls::Categories.new.force_delete_category(1446014)

        assert_includes([TrueClass, FalseClass], api_call.class)
      end

      test "force_delete_category returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Categories.any_instance.stubs(:delete).returns(response)

        api_call = LunchMoney::Calls::Categories.new.force_delete_category(784588)

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
