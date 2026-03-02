# frozen_string_literal: true

module LunchMoney
  module Calls
    module Transactions
      module Split
        include Base

        # Split a transaction into multiple parts.
        #
        # @param id [Integer] transaction ID to split
        # @param splits [Array<Hash, SplitTransaction>] split items with amount and optional fields
        # @return [Array<LunchMoney::Objects::Transaction>] the created child transactions
        def split_transaction(id, splits)
          split_objects = splits.map do |s|
            split = s.is_a?(Objects::SplitTransaction) ? s : Objects::SplitTransaction.new(**s)
            split.validate!
            split
          end
          data = post("/transactions/split/#{id}", body: { splits: split_objects.map(&:serialize) })
          build_collection(Objects::Transaction, data, key: :transactions)
        end

        # Unsplit a previously split transaction.
        #
        # @param id [Integer] transaction ID to unsplit
        # @return [nil]
        def unsplit_transaction(id)
          delete("/transactions/split/#{id}")
        end
      end
    end
  end
end
