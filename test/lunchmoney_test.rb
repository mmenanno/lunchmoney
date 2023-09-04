# typed: strict
# frozen_string_literal: true

require "test_helper"

class LunchMoneyTest < ActiveSupport::TestCase
  test "that is has a version number" do
    refute_nil(::LunchMoney::VERSION)
  end
end
