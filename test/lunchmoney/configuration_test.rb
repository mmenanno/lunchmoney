# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../lib/lunchmoney/configuration"

class LunchMoneyConfigurationTest < Minitest::Test
  def test_default_base_url
    config = LunchMoney::Configuration.new
    assert_equal "https://api.lunchmoney.dev/v2", config.base_url
  end

  def test_default_max_retries
    config = LunchMoney::Configuration.new
    assert_equal 3, config.max_retries
  end

  def test_api_key_defaults_to_env_variable
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

  def test_api_key_nil_when_env_not_set
    original = ENV["LUNCHMONEY_TOKEN"]
    ENV.delete("LUNCHMONEY_TOKEN")

    config = LunchMoney::Configuration.new
    assert_nil config.api_key
  ensure
    ENV["LUNCHMONEY_TOKEN"] = original if original
  end

  def test_api_key_can_be_overridden
    config = LunchMoney::Configuration.new
    config.api_key = "custom_key"
    assert_equal "custom_key", config.api_key
  end

  def test_base_url_can_be_overridden
    config = LunchMoney::Configuration.new
    config.base_url = "https://custom.example.com/v1"
    assert_equal "https://custom.example.com/v1", config.base_url
  end

  def test_max_retries_can_be_overridden
    config = LunchMoney::Configuration.new
    config.max_retries = 5
    assert_equal 5, config.max_retries
  end
end
