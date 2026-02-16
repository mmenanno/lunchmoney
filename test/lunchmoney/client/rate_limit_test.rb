# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../../lib/lunchmoney/client/rate_limit"

class LunchMoneyRateLimitTest < Minitest::Test
  def test_from_headers_with_valid_headers
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

  def test_from_headers_returns_nil_when_headers_missing
    headers = {}

    assert_nil LunchMoney::RateLimit.from_headers(headers)
  end

  def test_exhausted_true_when_remaining_zero
    rate_limit = LunchMoney::RateLimit.new(limit: 100, remaining: 0, reset: 1609459200)

    assert rate_limit.exhausted?
  end

  def test_exhausted_false_when_remaining_positive
    rate_limit = LunchMoney::RateLimit.new(limit: 100, remaining: 50, reset: 1609459200)

    refute rate_limit.exhausted?
  end

  def test_header_values_converted_to_integers
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
