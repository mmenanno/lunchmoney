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

remaining_args :commands

def run
  exec("bin/tapioca #{commands.join("")}")
end
