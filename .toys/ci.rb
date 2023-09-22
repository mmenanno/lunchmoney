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
  run_stage("Typecheck", ["tc"])
  run_stage("Verify Sigils", ["spoom", "verify"])
  run_stage("Verify Sorbet DSL RBIs", ["rbi", "dsl", "--verify"])
  run_stage("Tests", ["test"])
end
