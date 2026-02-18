# frozen_string_literal: true

module LunchMoney
  module Calls
    module Transactions
      module Group
        include Base

        # Group multiple transactions under a single parent transaction.
        #
        # @param transaction_ids [Array<Integer>] IDs of transactions to group
        # @param date [String] date for the group transaction
        # @param payee [String] payee name for the group transaction
        # @param attrs [Hash] optional: category_id:, notes:, tag_ids:
        # @return [LunchMoney::Objects::Transaction] the created group transaction
        def group_transactions(transaction_ids:, date:, payee:, **attrs)
          body = { transaction_ids:, date:, payee:, **attrs }.compact
          data = post("/transactions/group", body: body)
          build_object(Objects::Transaction, data)
        end

        # Remove a transaction group, restoring individual transactions.
        #
        # @param id [Integer] group transaction ID
        # @return [nil]
        def ungroup_transactions(id)
          delete("/transactions/group/#{id}")
        end
      end
    end
  end
end
