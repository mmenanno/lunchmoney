# typed: strict
# frozen_string_literal: true

require "test_helper"

module LunchMoney
  class ErrorsTest < ActiveSupport::TestCase
    setup do
      @error = T.let(LunchMoney::Errors.new, LunchMoney::Errors)
    end

    test "initializes error with message" do
      error = LunchMoney::Errors.new(message: "Some error message")

      assert_equal(["Some error message"], error.messages)
    end

    test "initializes error without message" do
      error = LunchMoney::Errors.new

      assert_empty(error.messages)
    end

    test "can add messages to error" do
      @error.messages << "Error 1"
      @error.messages << "Error 2"

      assert_equal(["Error 1", "Error 2"], @error.messages)
    end

    test "can get first message" do
      @error.messages << "Error 1"
      @error.messages << "Error 2"

      assert_equal("Error 1", @error.first)
    end

    test "can check if error messages are empty" do
      assert_empty(@error)
      @error.messages << "Error"

      refute_empty(@error)
    end
  end
end
