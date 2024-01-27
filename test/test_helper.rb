# typed: strict
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "sorbet-runtime"
require "dotenv/load"
require "lunchmoney-ruby"
require "minitest/autorun"
require "minitest/pride"
require "active_support"
require "mocha/minitest"
require "webmock/minitest"
require "vcr"
require "pry"

require_relative "helpers/configuration_stubs"
require_relative "helpers/environment_helper"
require_relative "helpers/mocha_typed"
require_relative "helpers/mock_response_helper"
require_relative "helpers/fake_response_data_helper"

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

module ActiveSupport
  class TestCase
    sig { void }
    def ensure_correct_api_key
      LunchMoney.configure do |config|
        config.api_key = ENV.fetch("LUNCHMONEY_TOKEN", nil)
      end
    end
  end
end
