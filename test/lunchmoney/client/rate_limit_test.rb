# frozen_string_literal: true

require "test_helper"

class LunchMoneyRateLimitTest < ActiveSupport::TestCase
  test "from_headers with valid headers" do
    headers = {
      "RateLimit-Limit" => "100",
      "RateLimit-Remaining" => "99",
      "RateLimit-Reset" => "1609459200",
    }

    rate_limit = LunchMoney::RateLimit.from_headers(headers)

    assert_equal 100, rate_limit.limit
    assert_equal 99, rate_limit.remaining
    assert_equal 1609459200, rate_limit.reset
  end

  test "from_headers returns nil when headers missing" do
    assert_nil LunchMoney::RateLimit.from_headers({})
  end

  test "exhausted? true when remaining zero" do
    rate_limit = LunchMoney::RateLimit.new(limit: 100, remaining: 0, reset: 1609459200)
    assert rate_limit.exhausted?
  end

  test "exhausted? false when remaining positive" do
    rate_limit = LunchMoney::RateLimit.new(limit: 100, remaining: 50, reset: 1609459200)
    refute rate_limit.exhausted?
  end

  test "header values converted to integers" do
    headers = {
      "RateLimit-Limit" => "200",
      "RateLimit-Remaining" => "150",
      "RateLimit-Reset" => "3600",
    }

    rate_limit = LunchMoney::RateLimit.from_headers(headers)

    assert_instance_of Integer, rate_limit.limit
    assert_instance_of Integer, rate_limit.remaining
    assert_instance_of Integer, rate_limit.reset
  end
end
