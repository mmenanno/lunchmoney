# typed: strict
# frozen_string_literal: true

require_relative "mocha_typed"

module MockResponseHelper
  include Mocha::Typed

  private

  sig do
    params(body: T.untyped).returns(Faraday::Response)
  end
  def mock_faraday_response(body)
    mock = instance_double(Faraday::Response)
    mock.stubs(:body).returns(body)
    mock
  end
end
