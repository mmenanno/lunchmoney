# frozen_string_literal: true

require "simplecov_json_formatter"

SimpleCov.formatter = if ENV.fetch("CI", false)
  SimpleCov::Formatter::JSONFormatter
else
  SimpleCov::Formatter::HTMLFormatter
end

SimpleCov.minimum_coverage(90)
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
    "lib/lunchmoney/deprecate.rb",
    "lib/lunchmoney/errors.rb",
    "lib/lunchmoney/exceptions.rb",
    "lib/lunchmoney/validators.rb",
    "lib/lunchmoney/version.rb",
  ]
end

# Minitest 6 made plugin auto-loading opt-in, so simplecov's bundled
# minitest plugin no longer activates on its own. When tests are launched
# via `toys` (which `require`s `minitest/autorun` before loading the test
# files that pull in simplecov), simplecov's own at_exit hook fires before
# Minitest gets to run any tests and reports a 0%-ish coverage failure.
# Wiring the plugin's behavior up manually defers the coverage check until
# after the suite has finished, restoring pre-Minitest-6 semantics.
if defined?(Minitest)
  SimpleCov.external_at_exit = true
  Minitest.after_run { SimpleCov.at_exit_behavior }
end
