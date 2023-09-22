# frozen_string_literal: true

tool :bump do
  def run
    exec("bin/spoom bump --from false --to true ;" \
      "bin/spoom bump --from true --to strict")
  end
end

tool :verify do
  def run
    exec("bin/spoom bump --from false --to true --dry ;" \
      "bin/spoom bump --from true --to strict --dry")
  end
end
