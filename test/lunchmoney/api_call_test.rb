# typed: strict
# frozen_string_literal: true

require "test_helper"

class ApiCallTest < ActiveSupport::TestCase
  include Mocha::Typed
  include MockResponseHelper

  test "errors returns and empty array if no errors are present" do
    response = mock_faraday_response({})

    errors = LunchMoney::ApiCall.new.send(:errors, response)

    assert_empty(errors)
  end

  test "errors returns errors when single error is returned" do
    error_message = "This is an error"
    response = mock_faraday_response({ error: error_message })

    errors = LunchMoney::ApiCall.new.send(:errors, response)

    refute_empty(errors)

    assert_equal(error_message, errors.first.message)
  end

  test "errors returns errors when multiple errors are returned" do
    error_messages = ["This is an error", "This is another error"]
    response = mock_faraday_response({ error: error_messages })

    errors = LunchMoney::ApiCall.new.send(:errors, response)

    refute_empty(errors)

    errors.each do |error|
      assert_includes(error_messages, error.message)
    end
  end
end
