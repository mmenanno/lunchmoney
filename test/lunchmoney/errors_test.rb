# frozen_string_literal: true

require "test_helper"

class LunchMoneyErrorsTest < ActiveSupport::TestCase
  test "Error inherits from StandardError" do
    assert LunchMoney::Error < StandardError
  end

  test "ApiError inherits from Error" do
    assert LunchMoney::ApiError < LunchMoney::Error
  end

  test "AuthenticationError inherits from ApiError" do
    assert LunchMoney::AuthenticationError < LunchMoney::ApiError
  end

  test "NotFoundError inherits from ApiError" do
    assert LunchMoney::NotFoundError < LunchMoney::ApiError
  end

  test "ValidationError inherits from ApiError" do
    assert LunchMoney::ValidationError < LunchMoney::ApiError
  end

  test "RateLimitError inherits from ApiError" do
    assert LunchMoney::RateLimitError < LunchMoney::ApiError
  end

  test "ServerError inherits from ApiError" do
    assert LunchMoney::ServerError < LunchMoney::ApiError
  end

  test "ClientValidationError inherits from Error" do
    assert LunchMoney::ClientValidationError < LunchMoney::Error
  end

  test "ConfigurationError inherits from Error" do
    assert LunchMoney::ConfigurationError < LunchMoney::Error
  end

  test "InvalidApiKey inherits from ConfigurationError" do
    assert LunchMoney::InvalidApiKey < LunchMoney::ConfigurationError
  end

  test "ApiError attributes" do
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

  test "ApiError default values" do
    error = LunchMoney::ApiError.new(status_code: 500, message: "Server error")

    assert_equal [], error.errors
    assert_nil error.response
    assert_nil error.rate_limit
  end

  test "RateLimitError retry_after" do
    error = LunchMoney::RateLimitError.new(
      retry_after: 30,
      status_code: 429,
      message: "Rate limited"
    )

    assert_equal 30, error.retry_after
    assert_equal 429, error.status_code
    assert_equal "Rate limited", error.message
  end

  test "RateLimitError retry_after defaults to nil" do
    error = LunchMoney::RateLimitError.new(status_code: 429, message: "Rate limited")
    assert_nil error.retry_after
  end

  test "rescue ApiError catches HTTP subclasses" do
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

  test "rescue Error catches all subclasses" do
    assert_raises(LunchMoney::Error) do
      raise LunchMoney::ApiError.new(status_code: 500, message: "test")
    end

    assert_raises(LunchMoney::Error) do
      raise LunchMoney::ClientValidationError, "test"
    end

    assert_raises(LunchMoney::Error) do
      raise LunchMoney::ConfigurationError, "test"
    end

    assert_raises(LunchMoney::Error) do
      raise LunchMoney::InvalidApiKey, "test"
    end
  end

  test "each error class can be instantiated" do
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

    client_validation = LunchMoney::ClientValidationError.new("test")
    assert_instance_of LunchMoney::ClientValidationError, client_validation

    config = LunchMoney::ConfigurationError.new("test")
    assert_instance_of LunchMoney::ConfigurationError, config

    invalid_key = LunchMoney::InvalidApiKey.new("test")
    assert_instance_of LunchMoney::InvalidApiKey, invalid_key
  end
end
