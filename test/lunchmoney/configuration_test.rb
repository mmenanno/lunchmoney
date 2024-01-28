# typed: strict
# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < ActiveSupport::TestCase
  include ConfigurationHelper

  test "token defaults to LUNCHMONEY_TOKEN variable when set" do
    with_environment({ "LUNCHMONEY_TOKEN" => "test_token" }) do
      assert_equal("test_token", LunchMoney::Configuration.new.api_key)
    end
  end

  test "token can be overwritten even if already set via ENV variable" do
    with_environment({ "LUNCHMONEY_TOKEN" => "test_token" }) do
      configuration = LunchMoney::Configuration.new
      configuration.api_key = "new_test_token"

      assert_equal("new_test_token", configuration.api_key)
    end
  end
end
