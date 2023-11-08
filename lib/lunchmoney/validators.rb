# typed: strict
# frozen_string_literal: true

require "time"

module LunchMoney
  module Validators
    include Kernel

    sig { params(value: String, valid_values: T::Array[String]).returns(String) }
    def validate_one_of!(value, valid_values)
      return value unless LunchMoney.validate_object_attributes?

      if valid_values.exclude?(value)
        raise(InvalidObjectAttribute, "#{value} is invalid, must be one of #{valid_values.join(", ")}")
      end

      value
    end

    sig { params(value: String).returns(String) }
    def validate_iso8601!(value)
      return value unless LunchMoney.validate_object_attributes?

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
