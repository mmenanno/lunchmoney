# typed: strict
# frozen_string_literal: true

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

  config.allow_http_connections_when_no_cassette = true if ENV.fetch("VCR_RECORD", nil)
end

if ENV.fetch("REMOTE_TESTS_ENABLED", nil)
  puts "Remote tests are enabled, ignoring VCR cassettes and enabling real HTTP connections"
  VCR.turn_off!(ignore_cassettes: true)
  WebMock.enable_net_connect!
elsif ENV.fetch("VCR_RECORD", nil)
  puts "VCR recording is enabled, recording VCR cassettes and enabling real HTTP connections"
  VCR.turn_on!
  WebMock.enable_net_connect!
else
  puts "Remote tests are disabled, using VCR cassettes and disabling real HTTP connections"
  VCR.turn_on!
  WebMock.disable_net_connect!
end
