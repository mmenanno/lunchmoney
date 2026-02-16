# frozen_string_literal: true

require_relative "mocha_typed"

module MockResponseHelper
  include Mocha::Typed

  private

  def mock_faraday_response(body)
    mock = instance_double(Faraday::Response)
    mock.stubs(:body).returns(body)
    mock
  end

  def mock_faraday_lunchmoney_error_response
    mock_faraday_response({ error: "This is an error" })
  end
end
