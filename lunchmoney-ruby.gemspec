# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "lunchmoney/version"

Gem::Specification.new do |spec|
  spec.name     = "lunchmoney-ruby"
  spec.version  = LunchMoney::VERSION
  spec.summary  = "LunchMoney API client library."
  spec.authors  = ["@halorrr"]
  spec.email    = "halorrr@gmail.com"
  spec.license  = "MIT"
  spec.require_paths = ["lib"]
  spec.files    = Dir.glob("lib/**/*.rb") + ["README.md", "Gemfile", "LICENSE"]
  spec.add_dependency "faraday", ">= 1.0"
  spec.add_dependency "faraday_middleware"
  spec.add_dependency "pry"
end
