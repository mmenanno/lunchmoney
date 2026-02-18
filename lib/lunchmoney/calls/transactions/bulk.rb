# frozen_string_literal: true

module LunchMoney
  module Calls
    module Transactions
      module Bulk
        include Base

        # Bulk update multiple transactions.
        #
        # @param transactions [Array<Hash, UpdateTransaction>] each must include :id and fields to update
        # @return [Array<LunchMoney::Objects::Transaction>]
        def update_transactions(transactions)
          txns = transactions.map do |t|
            txn = t.is_a?(Objects::UpdateTransaction) ? t : Objects::UpdateTransaction.new(**t)
            txn.validate!
            txn
          end
          data = put("/transactions", body: { transactions: txns.map(&:serialize) })
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
