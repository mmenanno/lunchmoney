# typed: strict
# frozen_string_literal: true

require "test_helper"

class ValidatorsTest < ActiveSupport::TestCase
  include ConfigurationStubs
  include LunchMoney::Validators

  setup do
    should_validate_object_attributes
  end

  test "validate_one_of validates values if validate_object_attributes is enabled" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      validate_one_of!("bad_value", ["good_value"])
    end

    assert_match(/is invalid, must be one of/, error.message)
  end

  test "validate_one_of does not validate values if validate_object_attributes is disabled" do
    remove_validate_object_attributes_expectation
    should_not_validate_object_attributes

    assert_nothing_raised do
      validate_one_of!("bad_value", ["good_value"])
    end
  end

  test "validate_one_of does not raise an error when set to a valid value" do
    assert_nothing_raised do
      validate_one_of!("good_value", ["good_value"])
    end
  end

  test "validate_one_of raises an error when set to an invalid value" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      validate_one_of!("bad_value", ["good_value"])
    end

    assert_match(/is invalid, must be one of/, error.message)
  end

  test "validate_iso8601 validates time if validate_object_attributes is enabled" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      validate_iso8601!("2023-01-01")
    end

    assert_match(/is not a valid ISO 8601 string/, error.message)
  end

  test "validate_iso8601 does not validate values if validate_object_attributes is disabled" do
    remove_validate_object_attributes_expectation
    should_not_validate_object_attributes

    assert_nothing_raised do
      validate_iso8601!("2023-01-01")
    end
  end

  test "validate_iso8601 does not raise an error when set to a valid value" do
    assert_nothing_raised do
      validate_iso8601!("2023-01-01T01:01:01.000Z")
    end
  end

  test "validate_iso8601 raises an error when set to an invalid value" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      validate_iso8601!("2023-01-01")
    end

    assert_match(/is not a valid ISO 8601 string/, error.message)
  end
end
