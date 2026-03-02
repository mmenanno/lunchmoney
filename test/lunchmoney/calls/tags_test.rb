# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class TagsTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      test "tags returns an array of Tag objects" do
        stub_lunchmoney(:get, "/tags", response: "tags/list")

        result = @api.tags

        assert_kind_of Array, result
        assert result.all? { |t| t.is_a?(LunchMoney::Objects::Tag) }
        assert_equal 3, result.length
      end

      test "tag returns a single Tag" do
        stub_lunchmoney(:get, "/tags/94319", response: "tags/get")

        result = @api.tag(94319)

        assert_instance_of LunchMoney::Objects::Tag, result
        assert_equal 94319, result.id
        assert_equal "Date Night", result.name
        assert_equal false, result.archived
      end

      test "tag raises NotFoundError on 404" do
        stub_lunchmoney_error(:get, "/tags/999999", status: 404, message: "Not found")

        error = assert_raises(LunchMoney::NotFoundError) { @api.tag(999999) }

        assert_equal 404, error.status_code
        assert_equal "Not found", error.message
      end

      test "create_tag returns created Tag" do
        stub_lunchmoney(:post, "/tags", response: "tags/create_name_only")

        result = @api.create_tag(name: "API Created Tag with no description")

        assert_instance_of LunchMoney::Objects::Tag, result
        assert_equal 94350, result.id
        assert_equal "API Created Tag with no description", result.name
        assert_nil result.description
      end

      test "update_tag returns updated Tag" do
        stub_lunchmoney(:put, "/tags/94319", response: "tags/update_new_name")

        result = @api.update_tag(94319, name: "Updated Tag Name")

        assert_instance_of LunchMoney::Objects::Tag, result
        assert_equal 94319, result.id
        assert_equal "Updated Tag Name", result.name
      end

      test "delete_tag returns nil on 204" do
        stub_lunchmoney(:delete, "/tags/94319", status: 204, body: nil)

        result = @api.delete_tag(94319)

        assert_nil result
      end
    end
  end
end
