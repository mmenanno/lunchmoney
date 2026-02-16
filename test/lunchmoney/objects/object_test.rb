# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Objects
    class ObjectTest < ActiveSupport::TestCase
      test "serialize returns a hash of instance variables" do
        object = create_test_object
        expected = {
          "name" => object.instance_variable_get(:@name),
          "type" => object.instance_variable_get(:@type),
          "subtype" => object.instance_variable_get(:@subtype),
          "balance" => object.instance_variable_get(:@balance),
          "balance_as_of" => object.instance_variable_get(:@balance_as_of),
          "created_at" => object.instance_variable_get(:@created_at),
        }

        assert_equal(expected, object.serialize)
      end

      test "serialize returns a hash of instance variables with symbolized keys" do
        object = create_test_object
        expected = {
          name: object.instance_variable_get(:@name),
          type: object.instance_variable_get(:@type),
          subtype: object.instance_variable_get(:@subtype),
          balance: object.instance_variable_get(:@balance),
          balance_as_of: object.instance_variable_get(:@balance_as_of),
          created_at: object.instance_variable_get(:@created_at),
        }

        assert_equal(expected, object.serialize(symbolize_keys: true))
      end

      private

      def create_test_object
        object = LunchMoney::Objects::Object.new
        object.instance_variable_set(:@name, "Test Name")
        object.instance_variable_set(:@type, "Test Type")
        object.instance_variable_set(:@subtype, "Test Subtype")
        object.instance_variable_set(:@balance, 1000)
        object.instance_variable_set(:@balance_as_of, "2023-01-01T01:01:01.000Z")
        object.instance_variable_set(:@created_at, "2023-01-01T01:01:01.000Z")

        object
      end
    end
  end
end
