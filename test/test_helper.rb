# typed: strict
# frozen_string_literal: true

require "simplecov"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "sorbet-runtime"
require "dotenv/load"
require "lunchmoney"
require "minitest/autorun"
require "minitest/pride"
require "active_support"
require "mocha/minitest"
require "webmock/minitest"
require "vcr"

require_relative "helpers/configuration_helper"
require_relative "helpers/deprecation_helper"
require_relative "helpers/mocha_typed"
require_relative "helpers/mock_response_helper"
require_relative "helpers/vcr_helper"

LunchMoney::Deprecate.endpoint_deprecation_warnings = false
