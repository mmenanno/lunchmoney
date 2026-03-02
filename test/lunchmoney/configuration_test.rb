# frozen_string_literal: true

require "test_helper"

class LunchMoneyConfigurationTest < ActiveSupport::TestCase
  test "default base_url" do
    config = LunchMoney::Configuration.new
    assert_equal "https://api.lunchmoney.dev/v2", config.base_url
  end

  test "default max_retries" do
    config = LunchMoney::Configuration.new
    assert_equal 3, config.max_retries
  end

  test "api_key defaults to ENV variable" do
    original = ENV["LUNCHMONEY_TOKEN"]
    ENV["LUNCHMONEY_TOKEN"] = "test_token_123"

    config = LunchMoney::Configuration.new
    assert_equal "test_token_123", config.api_key
  ensure
    if original
      ENV["LUNCHMONEY_TOKEN"] = original
    else
      ENV.delete("LUNCHMONEY_TOKEN")
    end
  end

  test "api_key nil when ENV not set" do
    original = ENV["LUNCHMONEY_TOKEN"]
    ENV.delete("LUNCHMONEY_TOKEN")

    config = LunchMoney::Configuration.new
    assert_nil config.api_key
  ensure
    ENV["LUNCHMONEY_TOKEN"] = original if original
  end

  test "api_key can be overridden" do
    config = LunchMoney::Configuration.new
    config.api_key = "custom_key"
    assert_equal "custom_key", config.api_key
  end

  test "base_url can be overridden" do
    config = LunchMoney::Configuration.new
    config.base_url = "https://custom.example.com/v1"
    assert_equal "https://custom.example.com/v1", config.base_url
  end

  test "max_retries can be overridden" do
    config = LunchMoney::Configuration.new
    config.max_retries = 5
    assert_equal 5, config.max_retries
  end
end
