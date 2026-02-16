# frozen_string_literal: true

require_relative "../objects/child_transaction"
require_relative "../objects/transaction"
require_relative "../objects/split"
require_relative "../objects/update_transaction"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#transactions
    class Transactions < LunchMoney::Calls::Base
      def transactions(
        tag_id: nil,
        recurring_id: nil,
        plaid_account_id: nil,
        category_id: nil,
        asset_id: nil,
        is_group: nil,
        status: nil,
        start_date: nil,
        end_date: nil,
        debit_as_negative: nil,
        pending: nil,
        offset: nil,
        limit: nil
      )
        params = clean_params({
          tag_id:,
          recurring_id:,
          plaid_account_id:,
          category_id:,
          asset_id:,
          is_group:,
          status:,
          start_date:,
          end_date:,
          debit_as_negative:,
          pending:,
          offset:,
          limit:,
        })
        response = get("transactions", query_params: params)

        handle_api_response(response) do |body|
          body[:transactions].map do |transaction|
            transaction[:tags].map! { |tag| LunchMoney::Objects::TagBase.new(**tag) }

            transaction[:children]&.map! do |child_transaction|
              LunchMoney::Objects::ChildTransaction.new(**child_transaction)
            end

            LunchMoney::Objects::Transaction.new(**transaction)
          end
        end
      end

      def transaction(transaction_id, debit_as_negative: nil)
        params = clean_params({ debit_as_negative: })
        response = get("transactions/#{transaction_id}", query_params: params)

        handle_api_response(response) do |body|
          LunchMoney::Objects::Transaction.new(**body)
        end
      end

      def insert_transactions(transactions, apply_rules: nil, skip_duplicates: nil,
        check_for_recurring: nil, debit_as_negative: nil, skip_balance_update: nil)
        params = clean_params({
          transactions: transactions.map(&:serialize),
          apply_rules:,
          skip_duplicates:,
          check_for_recurring:,
          debit_as_negative:,
          skip_balance_update:,
        })
        response = post("transactions", params)

        handle_api_response(response) do |body|
          body
        end
      end

      def update_transaction(transaction_id, transaction: nil, split: nil,
        debit_as_negative: nil, skip_balance_update: nil)
        raise(
          LunchMoney::MissingArgument,
          "Either a transaction or split must be provided",
        ) if transaction.nil? && split.nil?

        params = clean_params({
          transaction: transaction&.serialize,
          split: split&.map!(&:serialize),
          debit_as_negative:,
          skip_balance_update:,
        })
        response = put("transactions/#{transaction_id}", params)

        handle_api_response(response) do |body|
          body
        end
      end

      def unsplit_transaction(parent_ids, remove_parents: false)
        params = { parent_ids:, remove_parents: }
        response = post("transactions/unsplit", params)

        handle_api_response(response) do |body|
          body
        end
      end

      def transaction_group(transaction_id)
        response = get("transactions/group", query_params: { transaction_id: })

        handle_api_response(response) do |body|
          LunchMoney::Objects::Transaction.new(**body)
        end
      end

      def create_transaction_group(date:, payee:, transactions:, category_id: nil, notes: nil, tags: nil)
        params = clean_params({
          date:,
          payee:,
          transactions:,
          category_id:,
          notes:,
          tags:,
        })
        response = post("transactions/group", params)

        handle_api_response(response) do |body|
          body
        end
      end

      def delete_transaction_group(transaction_id)
        response = delete("transactions/group/#{transaction_id}")

        handle_api_response(response) do |body|
          body
        end
      end
    end
  end
end
