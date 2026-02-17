# frozen_string_literal: true

require "test_helper"

class TestObjectsBase < ActiveSupport::TestCase
  class SampleObject < LunchMoney::Objects::Base
    attr_accessor :name, :value, :count
  end

  test "initialize sets known attributes" do
    obj = SampleObject.new(name: "test", value: 42, count: 3)
    assert_equal "test", obj.name
    assert_equal 42, obj.value
    assert_equal 3, obj.count
  end

  test "initialize ignores unknown attributes" do
    obj = SampleObject.new(name: "test", unknown_key: "ignored")
    assert_equal "test", obj.name
    refute obj.instance_variable_defined?(:@unknown_key)
  end

  test "serialize returns hash of instance variables" do
    obj = SampleObject.new(name: "test", value: 42)
    result = obj.serialize
    assert_equal({ "name" => "test", "value" => 42 }, result)
  end

  test "serialize excludes hydrated ivars" do
    obj = SampleObject.new(name: "test")
    obj.instance_variable_set(:@_hydrated_category, "cached_category")
    result = obj.serialize
    assert_equal({ "name" => "test" }, result)
    refute result.key?("_hydrated_category")
  end

  test "hydrate calls block once and caches" do
    obj = SampleObject.new(name: "test")
    call_count = 0
    mock_client = Object.new

    2.times do
      obj.send(:hydrate, :related, client: mock_client) do |_client|
        call_count += 1
        "fetched_result"
      end
    end

    assert_equal 1, call_count
    assert_equal "fetched_result", obj.instance_variable_get(:@_hydrated_related)
  end

  test "hydrate returns result" do
    obj = SampleObject.new(name: "test")
    mock_client = Object.new

    result = obj.send(:hydrate, :thing, client: mock_client) { |_c| "the_thing" }
    assert_equal "the_thing", result
  end
end
