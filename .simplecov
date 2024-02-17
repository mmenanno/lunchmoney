# frozen_string_literal: true

require "simplecov_json_formatter"

SimpleCov.formatter = if ENV.fetch("CI", false)
  SimpleCov::Formatter::JSONFormatter
else
  SimpleCov::Formatter::HTMLFormatter
end

SimpleCov.minimum_coverage(95)
SimpleCov.maximum_coverage_drop(1)
SimpleCov.start do
  enable_coverage :branch
  primary_coverage :branch

  add_filter "/test/"

  add_group "Calls", "lib/lunchmoney/calls"
  add_group "Objects", "lib/lunchmoney/objects"
  add_group "Core Files", [
    "lib/lunchmoney.rb",
    "lib/lunchmoney/api.rb",
    "lib/lunchmoney/configuration.rb",
    "lib/lunchmoney/errors.rb",
    "lib/lunchmoney/exceptions.rb",
    "lib/lunchmoney/validators.rb",
    "lib/lunchmoney/version.rb",
  ]
end
