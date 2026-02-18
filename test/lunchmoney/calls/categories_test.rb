# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class CategoriesTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      test "categories returns an array of Category objects" do
        stub_lunchmoney(:get, "/categories", response: "categories/list_flattened_response")

        result = @api.categories

        assert_kind_of Array, result
        assert result.all? { |c| c.is_a?(LunchMoney::Objects::Category) }
        assert_equal 5, result.length
      end

      test "category returns a single Category" do
        stub_lunchmoney(:get, "/categories/315174", response: "categories/get_category")

        result = @api.category(315174)

        assert_instance_of LunchMoney::Objects::Category, result
        assert_equal 315174, result.id
        assert_equal "Fuel", result.name
        assert_equal "Fuel and gas expenses", result.description
        assert_equal false, result.is_income
        assert_equal 86, result.group_id
      end

      test "category raises NotFoundError on 404" do
        stub_lunchmoney_error(:get, "/categories/999999", status: 404, message: "Not found")

        error = assert_raises(LunchMoney::NotFoundError) { @api.category(999999) }

        assert_equal 404, error.status_code
        assert_equal "Not found", error.message
      end

      test "create_category returns created Category" do
        stub_lunchmoney(:post, "/categories", response: "categories/create_category")

        result = @api.create_category(name: "API Created Category", description: "Test description of created category")

        assert_instance_of LunchMoney::Objects::Category, result
        assert_equal 90, result.id
        assert_equal "API Created Category", result.name
        assert_equal true, result.exclude_from_budget
      end

      test "update_category returns updated Category" do
        stub_lunchmoney(:put, "/categories/83", response: "categories/update_category")

        result = @api.update_category(83, name: "Updated Category Name")

        assert_instance_of LunchMoney::Objects::Category, result
        assert_equal 83, result.id
        assert_equal "Updated Category Name", result.name
        assert_equal true, result.exclude_from_totals
      end

      test "delete_category returns nil on 204" do
        stub_lunchmoney(:delete, "/categories/83", status: 204, body: nil)

        result = @api.delete_category(83)

        assert_nil result
      end
    end
  end
end
