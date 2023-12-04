# typed: strict
# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < ActiveSupport::TestCase
  test "token defaults to LUNCHMONEY_TOKEN variable when set" do
    ENV["LUNCHMONEY_TOKEN"] = "test_token"

    assert_equal("test_token", LunchMoney::Configuration.new.api_key)
  end

  test "token can be overwritten even if already set via ENV variable" do
    ENV["LUNCHMONEY_TOKEN"] = "test_token"

    configuration = LunchMoney::Configuration.new
    configuration.api_key = "new_test_token"

    assert_equal("new_test_token", configuration.api_key)
  end
end