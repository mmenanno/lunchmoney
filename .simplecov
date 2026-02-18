# frozen_string_literal: true

SimpleCov.minimum_coverage line: 90
SimpleCov.start do
  enable_coverage :branch

  add_filter "/test/"
  add_filter "/generators/"

  add_group "Calls", "lib/lunchmoney/calls"
  add_group "Objects", "lib/lunchmoney/objects"
  add_group "Client", "lib/lunchmoney/client"
  add_group "Core Files", [
    "lib/lunchmoney.rb",
    "lib/lunchmoney/api.rb",
    "lib/lunchmoney/configuration.rb",
    "lib/lunchmoney/errors.rb",
    "lib/lunchmoney/version.rb",
  ]
end
