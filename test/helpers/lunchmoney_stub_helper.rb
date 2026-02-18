# frozen_string_literal: true

module LunchMoneyStubHelper
  BASE_URL = "https://api.lunchmoney.dev/v2"

  def stub_lunchmoney(method, path, status: 200, response: nil, body: nil, headers: {})
    default_headers = {
      "RateLimit-Limit" => "100",
      "RateLimit-Remaining" => "99",
      "RateLimit-Reset" => "60",
    }

    stub_request(method, "#{BASE_URL}#{path}")
      .with(headers: { "Authorization" => "Bearer test_api_key" })
      .to_return(
        status: status,
        body: response ? fixture_json(response) : body&.to_json,
        headers: default_headers.merge(headers).merge("Content-Type" => "application/json")
      )
  end

  def stub_lunchmoney_error(method, path, status:, message:, errors: [])
    stub_lunchmoney(method, path, status: status, body: { message: message, errors: errors })
  end
end
