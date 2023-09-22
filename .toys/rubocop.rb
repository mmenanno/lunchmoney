# frozen_string_literal: true

desc "Run the rubocop linter and perform safe autocorrections, use -A to auto correct all"
flag :autocorrect_all, "-A", "--autocorrect-all", "--all"

include :exec, exit_on_nonzero_status: true

def run
  autocorrect_all ? exec("bin/rubocop -A") : exec("bin/rubocop -a")
end
