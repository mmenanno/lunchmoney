# frozen_string_literal: true

require_relative "lib/lunchmoney/version"

Gem::Specification.new do |spec|
  spec.name                   = "lunchmoney"
  spec.version                = LunchMoney::VERSION
  spec.author                 = "@mmenanno"

  spec.summary                = "LunchMoney API client library."
  spec.homepage               = "https://github.com/mmenanno/lunchmoney"
  spec.required_ruby_version  = ">= 3.2"
  spec.license = "MIT"

  spec.metadata["allowed_push_host"]  = "https://rubygems.org"
  spec.metadata["homepage_uri"]       = spec.homepage
  spec.metadata["source_code_uri"]    = spec.homepage
  spec.metadata["documentation_uri"]  = "https://mmenanno.github.io/lunchmoney/"
  spec.metadata["changelog_uri"]      = "#{spec.homepage}/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    %x(git ls-files -z).split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("activesupport", ">= 6.1")
  spec.add_dependency("faraday", ">= 1.0.0")
  spec.add_dependency("sorbet-runtime", ">= 0.5")
end
