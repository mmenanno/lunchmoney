# typed: strict
# frozen_string_literal: true

require "test_helper"

class ConfigTest < ActiveSupport::TestCase
  test "token defaults to LUNCHMONEY_TOKEN variable when set" do
    ENV["LUNCHMONEY_TOKEN"] = "test_token"

    reload_config_class

    assert_equal("test_token", LunchMoney::Config.token)
  end

  test "token can be overwritten even if already set via ENV variable" do
    ENV["LUNCHMONEY_TOKEN"] = "test_token"
    reload_config_class

    LunchMoney::Config.token = "new_test_token"

    assert_equal("new_test_token", LunchMoney::Config.token)
  end

  private

  sig { void }
  def reload_config_class
    LunchMoney.send(:remove_const, :Config)

    config_file = $LOADED_FEATURES.find { |feature| feature.match?("lunchmoney-ruby/lib/lunchmoney/config.rb") }
    $LOADED_FEATURES.delete(config_file)

    require "./lib/lunchmoney/config"
  end
end
