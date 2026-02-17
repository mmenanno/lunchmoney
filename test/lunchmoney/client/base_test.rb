# frozen_string_literal: true

require "test_helper"

class TestClient < LunchMoney::Client::Base
  public :get, :post, :put, :delete
end

class LunchMoneyClientBaseTest < ActiveSupport::TestCase
  BASE_URL = "https://api.lunchmoney.dev/v2"

  setup do
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

  test "successful GET returns parsed body" do
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 200,
        body: { categories: [] }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    result = @client.get("/categories")
    assert_equal({ categories: [] }, result)
  end

  test "successful POST returns parsed body" do
    stub_request(:post, "#{BASE_URL}/transactions")
      .to_return(
        status: 201,
        body: { id: 1 }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    result = @client.post("/transactions", body: { name: "test" })
    assert_equal({ id: 1 }, result)
  end

  test "successful PUT returns parsed body" do
    stub_request(:put, "#{BASE_URL}/transactions/1")
      .to_return(
        status: 200,
        body: { updated: true }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    result = @client.put("/transactions/1", body: { name: "updated" })
    assert_equal({ updated: true }, result)
  end

  test "DELETE with 204 returns nil" do
    stub_request(:delete, "#{BASE_URL}/transactions/1")
      .to_return(
        status: 204,
        body: "",
        headers: rate_limit_headers
      )

    result = @client.delete("/transactions/1")
    assert_nil result
  end

  test "DELETE with 200 returns parsed body" do
    stub_request(:delete, "#{BASE_URL}/transactions/1")
      .to_return(
        status: 200,
        body: { deleted: true }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    result = @client.delete("/transactions/1")
    assert_equal({ deleted: true }, result)
  end

  test "400 raises ValidationError" do
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

  test "401 raises AuthenticationError" do
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 401,
        body: { message: "Unauthorized" }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::AuthenticationError) { @client.get("/categories") }
    assert_equal 401, error.status_code
  end

  test "404 raises NotFoundError" do
    stub_request(:get, "#{BASE_URL}/categories/999")
      .to_return(
        status: 404,
        body: { message: "Not found" }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::NotFoundError) { @client.get("/categories/999") }
    assert_equal 404, error.status_code
  end

  test "422 raises ValidationError" do
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

  test "429 raises RateLimitError with retry_after" do
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

  test "500 raises ServerError" do
    stub_request(:get, "#{BASE_URL}/categories")
      .to_return(
        status: 500,
        body: { message: "Internal server error" }.to_json,
        headers: { "Content-Type" => "application/json" }.merge(rate_limit_headers)
      )

    error = assert_raises(LunchMoney::ServerError) { @client.get("/categories") }
    assert_equal 500, error.status_code
  end

  test "exception contains response and rate_limit" do
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

  test "rate_limit updated after request" do
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

  test "Bearer auth header is sent" do
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
