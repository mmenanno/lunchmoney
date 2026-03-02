# frozen_string_literal: true

include :exec
include :terminal

def run_stage(name, tool)
  if exec_tool(tool).success?
    puts("** #{name} passed **", :green, :bold)
    puts
  else
    puts("** CI terminated: #{name} failed!", :red, :bold)
    exit(1)
  end
end

def run
  run_stage("Style Checker", ["rubocop"])
  run_stage("Markdown Lint", ["mdl"])
  run_stage("Tests", ["test"])
end
