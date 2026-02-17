# frozen_string_literal: true

require "simplecov"

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "lunchmoney"
require "minitest/autorun"
require "minitest/pride"
require "active_support"
require "active_support/test_case"
require "mocha/minitest"
require "webmock/minitest"

require_relative "helpers/configuration_helper"
require_relative "helpers/fixture_helper"
require_relative "helpers/lunchmoney_stub_helper"
