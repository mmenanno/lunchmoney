# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    class PlaidAccount < Base
      attr_accessor :id, :plaid_item_id, :date_linked, :linked_by_name, :name, :display_name, :type,
                    :subtype, :mask, :institution_name, :status,
                    :allow_transaction_modifications, :limit, :balance,
                    :currency, :to_base, :balance_last_update,
                    :import_start_date, :last_import, :last_fetch,
                    :plaid_last_successful_update
    end
  end
end
