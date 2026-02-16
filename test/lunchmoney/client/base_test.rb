# frozen_string_literal: true

require "minitest/autorun"
require "webmock/minitest"
require "faraday"
require "faraday/multipart"
require "faraday/retry"
require_relative "../../../lib/lunchmoney/errors"
require_relative "../../../lib/lunchmoney/configuration"
require_relative "../../../lib/lunchmoney/client/rate_limit"
require_relative "../../../lib/lunchmoney/client/base"

# Provide LunchMoney.configuration for tests
module LunchMoney
  LOCK = Mutex.new unless defined?(LOCK)
  class << self
    def configuration
      @configuration = nil unless defined?(@configuration)
      @configuration || LOCK.synchronize { @configuration ||= Configuration.new }
    end
  end
end

class TestClient < LunchMoney::Client::Base
  public :get, :post, :put, :delete
end

class LunchMoneyClientBaseTest < Minitest::Test
  BASE_URL = "https://api.lunchmoney.dev/v2"

  def setup
    LunchMoney.configuration.max_retries = 0
    @client = TestClient.new(api_key: "test_api_key")
  end

  def rate_limit_headers
    {
      "RateLimit-Limit" => "100",
      "RateLimit-Remaining" => "99",
      "RateLimit-Reset" => "1609459200",
    }
  end

  def test_successful_get_returns_parsed_body
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 200,
        body: { categories: [] }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    result = @client.get("/categories")
    assert_equal({ categories: [] }, result)
  end

  def test_successful_post_returns_parsed_body
    stub_request(:post, "#{BASE_URL}/transactions")
      .to_return(
        status: 201,
        body: { id: 1 }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    result = @client.post("/transactions", body: { name: "test" })
    assert_equal({ id: 1 }, result)
  end

  def test_successful_put_returns_parsed_body
    stub_request(:put, "#{BASE_URL}/transactions/1")
      .to_return(
        status: 200,
        body: { updated: true }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    result = @client.put("/transactions/1", body: { name: "updated" })
    assert_equal({ updated: true }, result)
  end

  def test_delete_with_204_returns_nil
    stub_request(:delete, "#{BASE_URL}/transactions/1")
      .to_return(
        status: 204,
        body: "",
        headers: rate_limit_headers
      )

    result = @client.delete("/transactions/1")
    assert_nil result
  end

  def test_delete_with_200_returns_parsed_body
    stub_request(:delete, "#{BASE_URL}/transactions/1")
      .to_return(
        status: 200,
        body: { deleted: true }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    result = @client.delete("/transactions/1")
    assert_equal({ deleted: true }, result)
  end

  def test_400_raises_validation_error
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 400,
        body: { message: "Bad request", errors: ["field required"] }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::ValidationError) { @client.get("/categories") }
    assert_equal 400, error.status_code
    assert_equal "Bad request", error.message
    assert_equal ["field required"], error.errors
  end

  def test_401_raises_authentication_error
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 401,
        body: { message: "Unauthorized" }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::AuthenticationError) { @client.get("/categories") }
    assert_equal 401, error.status_code
  end

  def test_404_raises_not_found_error
    stub_request(:get, "#{BASE_URL}/categories/999")
      .to_return(
        status: 404,
        body: { message: "Not found" }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::NotFoundError) { @client.get("/categories/999") }
    assert_equal 404, error.status_code
  end

  def test_422_raises_validation_error
    stub_request(:post, "#{BASE_URL}/transactions")
      .to_return(
        status: 422,
        body: { message: "Unprocessable", errors: ["invalid amount"] }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::ValidationError) { @client.post("/transactions") }
    assert_equal 422, error.status_code
    assert_equal ["invalid amount"], error.errors
  end

  def test_429_raises_rate_limit_error_with_retry_after
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 429,
        body: { message: "Rate limited" }.to_json,
        headers: { "Content-Type" => "application/json", "Retry-After" => "30" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::RateLimitError) { @client.get("/categories") }
    assert_equal 429, error.status_code
    assert_equal 30, error.retry_after
  end

  def test_500_raises_server_error
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 500,
        body: { message: "Internal server error" }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::ServerError) { @client.get("/categories") }
    assert_equal 500, error.status_code
  end

  def test_exception_contains_response_and_rate_limit
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 400,
        body: { message: "Bad request", errors: ["oops"] }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::ValidationError) { @client.get("/categories") }
    assert_equal "Bad request", error.message
    assert_equal ["oops"], error.errors
    refute_nil error.response
    refute_nil error.rate_limit
  end

  def test_rate_limit_updated_after_request
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 200,
        body: { categories: [] }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    assert_nil @client.rate_limit
    @client.get("/categories")

    refute_nil @client.rate_limit
    assert_equal 100, @client.rate_limit.limit
    assert_equal 99, @client.rate_limit.remaining
  end

  def test_bearer_auth_header_is_sent
    stub_request(:get, "#{BASE_URL}/categories")
      .with(headers: { "Authorization" => "Bearer test_api_key" })
      .to_return(
        status: 200,
        body: { categories: [] }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    @client.get("/categories")
    assert_requested(:get, "#{BASE_URL}/categories",
      headers: { "Authorization" => "Bearer test_api_key" })
  end
end
