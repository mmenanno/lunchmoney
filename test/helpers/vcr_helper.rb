# frozen_string_literal: true

module VcrHelper
  def with_real_ci_connections(&block)
    if ENV.fetch("REMOTE_TESTS_ENABLED", nil)
      VCR.turned_off(ignore_cassettes: true) do
        WebMock.enable_net_connect!
        block.call
      end
    else
      yield
    end
  ensure
    WebMock.disable_net_connect!
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes"
  config.hook_into(:webmock)
  config.default_cassette_options = { record: :once }

  config.filter_sensitive_data("<BEARER_TOKEN>") do |interaction|
    auths = interaction.request.headers["Authorization"].first
    if (match = auths.match(/^Bearer\s+([^,\s]+)/))
      match.captures.first
    end
  end

  config.filter_sensitive_data("<USER_NAME>") do |interaction|
    if interaction.request.uri == "https://dev.lunchmoney.app/v1/me"
      response = JSON.parse(interaction.response.body)
      response["user_name"]
    end
  end

  config.filter_sensitive_data("<USER_EMAIL>") do |interaction|
    if interaction.request.uri == "https://dev.lunchmoney.app/v1/me"
      response = JSON.parse(interaction.response.body)
      response["user_email"]
    end
  end
end
