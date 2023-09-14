# typed: strict
# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../lib", __dir__))

require "sorbet-runtime"
require "lunchmoney-ruby"
require "minitest/autorun"
require "active_support"
require "mocha/minitest"
require "pry"

require_relative "helpers/mocha_typed"
require_relative "helpers/mock_response_helper"
