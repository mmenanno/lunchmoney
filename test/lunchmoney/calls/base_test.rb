# frozen_string_literal: true

require "minitest/autorun"

$LOAD_PATH.unshift(File.expand_path("../../../lib", __dir__))
require "lunchmoney"
require "lunchmoney/calls/base"
require "lunchmoney/objects/base"
require "lunchmoney/objects/user"
require "lunchmoney/objects/category"

class CallsBaseTest < Minitest::Test
  include LunchMoney::Calls::Base

  def test_build_object_creates_instance_from_hash
    result = build_object(LunchMoney::Objects::User, { id: 1, user_name: "Test", user_email: "test@example.com",
                                                       budget_name: "Test Budget", api_key_label: "key" })
    assert_kind_of LunchMoney::Objects::User, result
    assert_equal 1, result.id
  end

  def test_build_object_returns_nil_for_nil_data
    assert_nil build_object(LunchMoney::Objects::User, nil)
  end

  def test_build_collection_maps_array_with_key
    data = { categories: [{ id: 1, name: "Food" }, { id: 2, name: "Rent" }] }
    result = build_collection(LunchMoney::Objects::Category, data, key: :categories)
    assert_equal 2, result.length
    assert_kind_of LunchMoney::Objects::Category, result.first
  end

  def test_build_collection_maps_array_without_key
    data = [{ id: 1, name: "Food" }, { id: 2, name: "Rent" }]
    result = build_collection(LunchMoney::Objects::Category, data)
    assert_equal 2, result.length
  end

  def test_build_collection_returns_empty_array_for_nil_data
    assert_equal [], build_collection(LunchMoney::Objects::Category, nil)
  end

  def test_build_collection_returns_empty_array_when_key_not_found
    assert_equal [], build_collection(LunchMoney::Objects::Category, {}, key: :categories)
  end
end
