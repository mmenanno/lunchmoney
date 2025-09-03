# typed: strict
# frozen_string_literal: true

require "time"

module LunchMoney
  # module containing reusable methods for validating data objects
  module Validators
    include Kernel

    sig { params(value: String, valid_values: T::Array[String], validate: T.nilable(T::Boolean)).returns(String) }
    def validate_one_of!(value, valid_values, validate: nil)
      should_validate = validate.nil? ? LunchMoney.validate_object_attributes? : validate
      return value unless should_validate

      if valid_values.exclude?(value)
        raise(InvalidObjectAttribute, "#{value} is invalid, must be one of #{valid_values.join(", ")}")
      end

      value
    end

    sig { params(value: String, validate: T.nilable(T::Boolean)).returns(String) }
    def validate_iso8601!(value, validate: nil)
      should_validate = validate.nil? ? LunchMoney.validate_object_attributes? : validate
      return value unless should_validate

      raise(InvalidObjectAttribute, "#{value} is not a valid ISO 8601 string") unless valid_iso8601_string?(value)

      value
    end

    private

    sig { params(time_string: String).returns(T::Boolean) }
    def valid_iso8601_string?(time_string)
      Time.iso8601(time_string)
      true
    rescue ArgumentError => error
      raise unless error.message.match?("invalid xmlschema format")

      false
    end
  end
end
