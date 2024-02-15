# frozen_string_literal: true

def run
  exec("mdl -s ./.mdlrc --git-recurse --show-aliases .")
end
