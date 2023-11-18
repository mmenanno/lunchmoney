# frozen_string_literal: true

tool :gem do
  optional_arg :gem_name

  def run
    exec("bin/tapioca gem #{gem_name}")
  end
end

tool :gems do
  flag :all, "--all"
  def run
    if all
      exec("bin/tapioca gems --all")
    else
      exec("bin/tapioca gems")
    end
  end
end

tool :dsl do
  flag :verify, "--verify"
  def run
    if verify
      exec("bin/tapioca dsl --verify")
    else
      exec("bin/tapioca dsl")
    end
  end
end

tool :all_types do
  include :exec
  include :terminal

  def run_stage(name, tool)
    puts("** #{name} started **", :blue, :bold)

    if exec_tool(tool).success?
      puts("** #{name} succeeded **", :green, :bold)
      puts
    else
      puts("** CI terminated: #{name} failed!", :red, :bold)
      exit(1)
    end
  end

  def run
    run_stage("Update Gem RBIs", ["rbi", "gems"])
    run_stage("Update DSL RBIs", ["rbi", "dsl"])
    run_stage("Update Annotations RBIs", ["rbi", "annotations"])
  end
end

remaining_args :commands

def run
  exec("bin/tapioca #{commands.join("")}")
end
