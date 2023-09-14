# typed: strict
# frozen_string_literal: true

require_relative "mocha_typed"

module MockResponseHelper
  include Mocha::Typed

  private

  sig { params(body: T::Hash[Symbol, T.untyped]).returns(Faraday::Response) }
  def mock_faraday_response(body)
    mock = instance_double(Faraday::Response)
    mock.stubs(:body).returns(body)
    mock
  end
end
