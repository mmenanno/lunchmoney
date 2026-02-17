# frozen_string_literal: true

module LunchMoney
  module Calls
    module Transactions
      include Base

      # Fetch a single page of transactions.
      #
      # @param start_date [String] ISO 8601 date
      # @param end_date [String] ISO 8601 date
      # @param limit [Integer] 1-2000, default 1000
      # @param offset [Integer] default 0
      # @param filters [Hash] optional filters (tag_id:, recurring_id:, category_id:,
      #   plaid_account_id:, manual_account_id:, status:, is_group_parent:)
      # @return [Hash] { transactions: Array<Transaction>, has_more: Boolean }
      def transactions_page(start_date:, end_date:, limit: 1000, offset: 0, **filters)
        params = { start_date:, end_date:, limit:, offset:, **filters }.compact
        data = get("/transactions", params: params)
        {
          transactions: build_collection(Objects::Transaction, data, key: :transactions),
          has_more: data[:has_more],
        }
      end

      # List transactions with auto-pagination.
      #
      # Returns all transactions by fetching pages automatically. When Client::Pagination
      # is available (Phase 04), this will return a lazy Enumerable instead.
      #
      # @param start_date [String] ISO 8601 date
      # @param end_date [String] ISO 8601 date
      # @param filters [Hash] optional filters
      # @return [Array<LunchMoney::Objects::Transaction>]
      def transactions(start_date:, end_date:, **filters)
        all_transactions = []
        offset = 0
        limit = 1000

        loop do
          page = transactions_page(start_date:, end_date:, limit:, offset:, **filters)
          all_transactions.concat(page[:transactions])
          break unless page[:has_more]

          offset += limit
        end

        all_transactions
      end

      # Get a single transaction by ID.
      #
      # @param id [Integer]
      # @return [LunchMoney::Objects::Transaction]
      # @raise [LunchMoney::NotFoundError]
      def transaction(id)
        data = get("/transactions/#{id}")
        build_object(Objects::Transaction, data)
      end

      # Create a single transaction (convenience wrapper).
      #
      # @param attrs [Hash] transaction attributes (date:, amount:, payee:, category_id:, etc.)
      # @return [LunchMoney::Objects::Transaction]
      def create_transaction(**attrs)
        txn = Objects::InsertTransaction.new(**attrs)
        txn.validate!
        data = post("/transactions", body: { transactions: [txn.serialize] })
        build_collection(Objects::Transaction, data, key: :transactions).first
      end

      # Create multiple transactions.
      #
      # @param transactions [Array<InsertTransaction, Hash>]
      # @param options [Hash] apply_rules:, skip_duplicates:, check_for_recurring:, skip_balance_update:
      # @return [LunchMoney::Objects::InsertTransactionsResponse]
      def create_transactions(transactions, **options)
        txns = transactions.map do |t|
          txn = t.is_a?(Objects::InsertTransaction) ? t : Objects::InsertTransaction.new(**t)
          txn.validate!
          txn
        end
        body = { transactions: txns.map(&:serialize), **options }.compact
        data = post("/transactions", body: body)
        build_object(Objects::InsertTransactionsResponse, data)
      end

      # Update a transaction.
      #
      # @param id [Integer]
      # @param attrs [Hash] attributes to update
      # @return [LunchMoney::Objects::Transaction]
      def update_transaction(id, **attrs)
        data = put("/transactions/#{id}", body: attrs)
        build_object(Objects::Transaction, data)
      end

      # Delete a transaction. New in v2.
      #
      # @param id [Integer]
      # @return [nil]
      def delete_transaction(id)
        delete("/transactions/#{id}")
      end
    end
  end
end
