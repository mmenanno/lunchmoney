# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    module Summary
      class NonAlignedSummaryResponse < Base
        attr_accessor :totals, :aligned, :categories

        def aligned?
          false
        end
      end
    end
  end
end
