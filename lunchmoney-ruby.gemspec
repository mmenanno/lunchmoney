# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "lunchmoney/version"

Gem::Specification.new do |spec|
  spec.name               = "lunchmoney-ruby"
  spec.version            = LunchMoney::VERSION
  spec.author             = "@halorrr"
  spec.email              = "halorrr@gmail.com"
  spec.summary            = "LunchMoney API client library."
  spec.homepage           = "https://github.com/halorrr/lunchmoney-ruby"
  spec.license            = "MIT"

  spec.require_paths      = ["lib"]

  spec.files              = Dir.glob("lib/**/*.rb") + ["README.md", "Gemfile", "LICENSE"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.add_dependency("faraday", "~> 1.5.1")
  spec.add_dependency("faraday_middleware", "~> 1.0.0")
end
