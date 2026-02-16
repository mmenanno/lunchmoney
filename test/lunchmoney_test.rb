# frozen_string_literal: true

require "test_helper"

class LunchMoneyTest < ActiveSupport::TestCase
  include ConfigurationHelper

  test "that is has a version number" do
    refute_nil(::LunchMoney::VERSION)
  end

  test "configure block can be used to set api_key" do
    with_safe_api_key_changes do
      LunchMoney.configuration.api_key = nil

      assert_nil(LunchMoney.configuration.api_key)

      LunchMoney.configure do |config|
        config.api_key = "api_key"
      end

      assert_equal("api_key", LunchMoney.configuration.api_key)
    end
  end

  test "configure block can be used to change api_key" do
    with_safe_api_key_changes do
      LunchMoney.configuration.api_key = "old_api_key"

      refute_nil(LunchMoney.configuration.api_key)

      LunchMoney.configure do |config|
        config.api_key = "new_api_key"
      end

      assert_equal("new_api_key", LunchMoney.configuration.api_key)
    end
  end
end
