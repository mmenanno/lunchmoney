# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    class RecurringItem < Base
      attr_accessor :id, :description, :status, :transaction_criteria, :overrides, :matches,
                    :created_by, :created_at, :updated_at, :source
    end
  end
end
