# typed: strict
# frozen_string_literal: true

require_relative "transaction"
require_relative "update_transaction"
require_relative "split"

module LunchMoney
  class TransactionCalls < ApiCall
    sig do
      params(
        tag_id: T.nilable(Integer),
        recurring_id: T.nilable(Integer),
        plaid_account_id: T.nilable(Integer),
        category_id: T.nilable(Integer),
        asset_id: T.nilable(Integer),
        group_id: T.nilable(Integer),
        is_group: T.nilable(T::Boolean),
        status: T.nilable(String),
        offset: T.nilable(Integer),
        limit: T.nilable(Integer),
        start_date: T.nilable(String),
        end_date: T.nilable(String),
        debit_as_negative: T.nilable(T::Boolean),
        pending: T.nilable(T::Boolean),
      ).returns(T::Array[LunchMoney::Transaction])
    end
    def transactions(
      tag_id: nil,
      recurring_id: nil,
      plaid_account_id: nil,
      category_id: nil,
      asset_id: nil,
      group_id: nil,
      is_group: nil,
      status: nil,
      offset: nil,
      limit: nil,
      start_date: nil,
      end_date: nil,
      debit_as_negative: nil,
      pending: nil
    )

      params = {
        tag_id:,
        recurring_id:,
        plaid_account_id:,
        category_id:,
        asset_id:,
        group_id:,
        is_group:,
        status:,
        offset:,
        limit:,
        start_date:,
        end_date:,
        debit_as_negative:,
        pending:,
      }
      params.reject! { |_key, value| value.nil? }

      response = if params.empty?
        get("transactions")
      else
        get("transactions", query_params: params)
      end

      errors(response)

      response.body[:transactions].map do |transaction|
        transaction[:tags]&.map! { |tag| LunchMoney::Tag.new(tag) }

        LunchMoney::Transaction.new(transaction)
      end
    end

    sig { params(transaction_id: Integer, debit_as_negative: T.nilable(T::Boolean)).returns(LunchMoney::Transaction) }
    def single_transaction(transaction_id:, debit_as_negative: nil)
      params = {
        debit_as_negative:,
      }
      params.reject! { |_key, value| value.nil? }

      response = if params.empty?
        get("transactions/#{transaction_id}")
      else
        get("transactions/#{transaction_id}", query_params: params)
      end

      errors(response)

      LunchMoney::Transaction.new(response.body)
    end

    sig do
      params(
        transactions: T::Array[LunchMoney::Transaction],
        apply_rules: T.nilable(T::Boolean),
        skip_duplicates: T.nilable(T::Boolean),
        check_for_recurring: T.nilable(T::Boolean),
        debit_as_negative: T.nilable(T::Boolean),
        skip_balance_update: T.nilable(T::Boolean),
      ).returns(T::Hash[String, T::Array[Integer]])
    end
    def insert_transactions(transactions, apply_rules: nil, skip_duplicates: nil,
      check_for_recurring: nil, debit_as_negative: nil, skip_balance_update: nil)
      params = {
        transactions: transactions.map(&:serialize),
        apply_rules:,
        skip_duplicates:,
        check_for_recurring:,
        debit_as_negative:,
        skip_balance_update:,
      }
      params.reject! { |_key, value| value.nil? }

      response = post("transactions", params)

      errors(response)

      response.body
    end

    sig do
      params(
        transaction_id: Integer,
        transaction: LunchMoney::UpdateTransaction,
        split: T.nilable(LunchMoney::Split),
        debit_as_negative: T.nilable(T::Boolean),
        skip_balance_update: T.nilable(T::Boolean),
      ).returns({ updated: T::Boolean, split: T::Array[Integer] })
    end
    def update_transaction(transaction_id, transaction:, split: nil,
      debit_as_negative: nil, skip_balance_update: nil)
      params = {
        transaction: transaction.serialize,
        split: split&.serialize,
        debit_as_negative:,
        skip_balance_update:,
      }
      params.reject! { |_key, value| value.nil? }

      response = put("transactions/#{transaction_id}", params)

      errors(response)

      response.body
    end

    sig { params(parent_ids: T::Array[Integer], remove_parents: T.nilable(T::Boolean)).returns(T::Array[Integer]) }
    def unsplit_transaction(parent_ids, remove_parents:)
      params = {
        parent_ids:,
        remove_parents:,
      }
      params.reject! { |_key, value| value.nil? }

      response = post("transactions/unsplit", params)

      errors(response)

      response.body
    end

    sig do
      params(
        date: String,
        payee: String,
        transactions: T::Array[T.any(Integer, String)],
        category_id: T.nilable(Integer),
        notes: T.nilable(String),
        tags: T.nilable(T::Array[T.any(Integer, String)]),
      ).returns(Integer)
    end
    def create_transaction_group(date:, payee:, transactions:, category_id: nil, notes: nil, tags: nil)
      params = {
        date:,
        payee:,
        transactions:,
        category_id:,
        notes:,
        tags:,
      }
      params.reject! { |_key, value| value.nil? }

      response = post("transactions/group", params)

      errors(response)

      response.body
    end

    sig { params(transaction_id: T.any(String, Integer)).returns(T::Hash[String, T::Array[Integer]]) }
    def delete_transaction_group(transaction_id)
      response = delete("transactions/group/#{transaction_id}")

      errors(response)

      response.body
    end
  end
end
