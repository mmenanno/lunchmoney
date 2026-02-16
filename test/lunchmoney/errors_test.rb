# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../lib/lunchmoney/errors"

class LunchMoneyErrorsTest < Minitest::Test
  def test_error_inherits_from_standard_error
    assert LunchMoney::Error < StandardError
  end

  def test_api_error_inherits_from_error
    assert LunchMoney::ApiError < LunchMoney::Error
  end

  def test_authentication_error_inherits_from_api_error
    assert LunchMoney::AuthenticationError < LunchMoney::ApiError
  end

  def test_not_found_error_inherits_from_api_error
    assert LunchMoney::NotFoundError < LunchMoney::ApiError
  end

  def test_validation_error_inherits_from_api_error
    assert LunchMoney::ValidationError < LunchMoney::ApiError
  end

  def test_rate_limit_error_inherits_from_api_error
    assert LunchMoney::RateLimitError < LunchMoney::ApiError
  end

  def test_server_error_inherits_from_api_error
    assert LunchMoney::ServerError < LunchMoney::ApiError
  end

  def test_configuration_error_inherits_from_error
    assert LunchMoney::ConfigurationError < LunchMoney::Error
  end

  def test_invalid_api_key_inherits_from_configuration_error
    assert LunchMoney::InvalidApiKey < LunchMoney::ConfigurationError
  end

  def test_api_error_attributes
    error = LunchMoney::ApiError.new(
      status_code: 400,
      message: "Bad request",
      errors: ["field is required"],
      response: "raw_response",
      rate_limit: "rate_limit_obj"
    )

    assert_equal 400, error.status_code
    assert_equal "Bad request", error.message
    assert_equal ["field is required"], error.errors
    assert_equal "raw_response", error.response
    assert_equal "rate_limit_obj", error.rate_limit
  end

  def test_api_error_default_values
    error = LunchMoney::ApiError.new(status_code: 500, message: "Server error")

    assert_equal [], error.errors
    assert_nil error.response
    assert_nil error.rate_limit
  end

  def test_rate_limit_error_retry_after
    error = LunchMoney::RateLimitError.new(
      retry_after: 30,
      status_code: 429,
      message: "Rate limited"
    )

    assert_equal 30, error.retry_after
    assert_equal 429, error.status_code
    assert_equal "Rate limited", error.message
  end

  def test_rate_limit_error_retry_after_defaults_to_nil
    error = LunchMoney::RateLimitError.new(status_code: 429, message: "Rate limited")

    assert_nil error.retry_after
  end

  def test_rescue_api_error_catches_http_subclasses
    [
      LunchMoney::AuthenticationError,
      LunchMoney::NotFoundError,
      LunchMoney::ValidationError,
      LunchMoney::RateLimitError,
      LunchMoney::ServerError,
    ].each do |klass|
      assert_raises(LunchMoney::ApiError) do
        raise klass.new(status_code: 500, message: "test")
      end
    end
  end

  def test_rescue_error_catches_all_subclasses
    assert_raises(LunchMoney::Error) do
      raise LunchMoney::ApiError.new(status_code: 500, message: "test")
    end

    assert_raises(LunchMoney::Error) do
      raise LunchMoney::ConfigurationError, "test"
    end

    assert_raises(LunchMoney::Error) do
      raise LunchMoney::InvalidApiKey, "test"
    end
  end

  def test_each_error_class_can_be_instantiated
    api_error = LunchMoney::ApiError.new(status_code: 400, message: "test")
    assert_instance_of LunchMoney::ApiError, api_error

    auth_error = LunchMoney::AuthenticationError.new(status_code: 401, message: "test")
    assert_instance_of LunchMoney::AuthenticationError, auth_error

    not_found = LunchMoney::NotFoundError.new(status_code: 404, message: "test")
    assert_instance_of LunchMoney::NotFoundError, not_found

    validation = LunchMoney::ValidationError.new(status_code: 422, message: "test")
    assert_instance_of LunchMoney::ValidationError, validation

    rate_limit = LunchMoney::RateLimitError.new(status_code: 429, message: "test")
    assert_instance_of LunchMoney::RateLimitError, rate_limit

    server = LunchMoney::ServerError.new(status_code: 500, message: "test")
    assert_instance_of LunchMoney::ServerError, server

    config = LunchMoney::ConfigurationError.new("test")
    assert_instance_of LunchMoney::ConfigurationError, config

    invalid_key = LunchMoney::InvalidApiKey.new("test")
    assert_instance_of LunchMoney::InvalidApiKey, invalid_key
  end
end
