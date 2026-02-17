# frozen_string_literal: true

module LunchMoney
  module Calls
    module Transactions
      module Bulk
        include Base

        # Bulk update multiple transactions.
        #
        # @param transactions [Array<Hash>] each Hash must include :id and fields to update
        # @return [Array<LunchMoney::Objects::Transaction>]
        def update_transactions(transactions)
          data = put("/transactions", body: { transactions: transactions })
          build_collection(Objects::Transaction, data, key: :transactions)
        end

        # Bulk delete multiple transactions. New in v2.
        #
        # @param ids [Array<Integer>] transaction IDs to delete
        # @return [nil]
        def delete_transactions(ids)
          delete("/transactions", params: { ids: ids })
        end
      end
    end
  end
end
