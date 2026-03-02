# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    class ManualAccount < Base
      attr_accessor :id, :name, :institution_name, :display_name, :type, :subtype, :balance,
                    :currency, :to_base, :balance_as_of, :status, :closed_on,
                    :external_id, :custom_metadata, :exclude_from_transactions,
                    :created_by_name, :created_at, :updated_at
    end
  end
end
