# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    module Summary
      class AlignedSummaryResponse < Base
        attr_accessor :totals, :aligned, :categories

        def aligned?
          true
        end
      end
    end
  end
end
