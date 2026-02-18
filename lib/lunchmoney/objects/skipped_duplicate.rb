# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    class SkippedDuplicate < Base
      attr_accessor :reason, :request_transactions_index, :existing_transaction_id,
                    :request_transaction
    end
  end
end
