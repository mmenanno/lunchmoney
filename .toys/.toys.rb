# frozen_string_literal: true

expand :minitest, files: ["test/**/*_test.rb"], libs: ["test", "lib"]
expand :gem_build
expand :gem_build, name: "install", install_gem: true
expand :gem_build, name: "release", push_gem: true

alias_tool :style, :rubocop
alias_tool :tapioca, :rbi
alias_tool :tc, :typecheck
alias_tool :cov, :coverage
