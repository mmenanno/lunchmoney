# typed: strict
# frozen_string_literal: true

require_relative "transaction/transaction_base"
require_relative "transaction/child_transaction"
require_relative "transaction/transaction"
require_relative "transaction/transaction_modification_base"
require_relative "transaction/split"
require_relative "transaction/update_transaction"

module LunchMoney
  # https://lunchmoney.dev/#transactions
  class TransactionCalls < ApiCall
    sig do
      params(
        tag_id: T.nilable(Integer),
        recurring_id: T.nilable(Integer),
        plaid_account_id: T.nilable(Integer),
        category_id: T.nilable(Integer),
        asset_id: T.nilable(Integer),
        is_group: T.nilable(T::Boolean),
        status: T.nilable(String),
        start_date: T.nilable(String),
        end_date: T.nilable(String),
        debit_as_negative: T.nilable(T::Boolean),
        pending: T.nilable(T::Boolean),
        offset: T.nilable(Integer),
        limit: T.nilable(Integer),
      ).returns(T.any(T::Array[LunchMoney::Transaction], LunchMoney::Errors))
    end
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

      params = {
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
      }
      params.reject! { |_key, value| value.nil? }

      response = if params.empty?
        get("transactions")
      else
        get("transactions", query_params: params)
      end

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body[:transactions].map do |transaction|
        transaction[:tags].map! { |tag| LunchMoney::TagBase.new(**tag) }

        transaction[:children]&.map! { |child_transaction| LunchMoney::ChildTransaction.new(**child_transaction) }

        LunchMoney::Transaction.new(**transaction)
      end
    end

    sig do
      params(
        transaction_id: Integer,
        debit_as_negative: T.nilable(T::Boolean),
      ).returns(T.any(LunchMoney::Transaction, LunchMoney::Errors))
    end
    def transaction(transaction_id, debit_as_negative: nil)
      params = {
        debit_as_negative:,
      }
      params.reject! { |_key, value| value.nil? }

      response = if params.empty?
        get("transactions/#{transaction_id}")
      else
        get("transactions/#{transaction_id}", query_params: params)
      end

      api_errors = errors(response)
      return api_errors if api_errors.present?

      LunchMoney::Transaction.new(**response.body)
    end

    sig do
      params(
        transactions: T::Array[LunchMoney::Transaction],
        apply_rules: T.nilable(T::Boolean),
        skip_duplicates: T.nilable(T::Boolean),
        check_for_recurring: T.nilable(T::Boolean),
        debit_as_negative: T.nilable(T::Boolean),
        skip_balance_update: T.nilable(T::Boolean),
      ).returns(T.any(T::Hash[String, T::Array[Integer]], LunchMoney::Errors))
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

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body
    end

    sig do
      params(
        transaction_id: Integer,
        transaction: LunchMoney::UpdateTransaction,
        split: T.nilable(LunchMoney::Split),
        debit_as_negative: T.nilable(T::Boolean),
        skip_balance_update: T.nilable(T::Boolean),
      ).returns(T.any({ updated: T::Boolean, split: T::Array[Integer] }, LunchMoney::Errors))
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

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body
    end

    sig do
      params(
        parent_ids: T::Array[Integer],
        remove_parents: T.nilable(T::Boolean),
      ).returns(T.any(T::Array[Integer], LunchMoney::Errors))
    end
    def unsplit_transaction(parent_ids, remove_parents:)
      params = {
        parent_ids:,
        remove_parents:,
      }
      params.reject! { |_key, value| value.nil? }

      response = post("transactions/unsplit", params)

      api_errors = errors(response)
      return api_errors if api_errors.present?

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
      ).returns(T.any(Integer, LunchMoney::Errors))
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

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body
    end

    sig do
      params(transaction_id: T.any(
        String,
        Integer,
      )).returns(T.any(T::Hash[String, T::Array[Integer]], LunchMoney::Errors))
    end
    def delete_transaction_group(transaction_id)
      response = delete("transactions/group/#{transaction_id}")

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body
    end
  end
end
