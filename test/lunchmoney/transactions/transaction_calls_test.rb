# typed: strict
# frozen_string_literal: true

require "test_helper"

class TransactionCallsTest < ActiveSupport::TestCase
  include MockResponseHelper

  test "transactions returns an array of Transaction objects on success response" do
    VCR.use_cassette("transactions/transactions_success") do
      api_call = LunchMoney::TransactionCalls.new.transactions(start_date: "2019-01-01", end_date: "2025-01-01")

      api_call.each do |transaction|
        assert_kind_of(LunchMoney::Transaction, transaction)
      end
    end
  end

  test "transactions returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::TransactionCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::TransactionCalls.new.transactions(start_date: "2019-01-01", end_date: "2025-01-01")

    api_call.each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  test "transaction returns a Transaction objects on success response" do
    VCR.use_cassette("transactions/transaction_success") do
      api_call = LunchMoney::TransactionCalls.new.transaction(893631800)

      assert_kind_of(LunchMoney::Transaction, api_call)
    end
  end

  test "transaction returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::TransactionCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::TransactionCalls.new.transaction(893631800)

    T.unsafe(api_call).each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  test "transaction_group returns a Transaction objects on success response" do
    VCR.use_cassette("transactions/transaction_group_success") do
      api_call = LunchMoney::TransactionCalls.new.transaction(894063595)

      assert_kind_of(LunchMoney::Transaction, api_call)
    end
  end

  test "transaction_group returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::TransactionCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::TransactionCalls.new.transaction(893631800)

    T.unsafe(api_call).each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  test "insert_transactions returns a hash containing an array of ids on success response" do
    VCR.use_cassette("transactions/insert_transactions_success") do
      api_call = LunchMoney::TransactionCalls.new.insert_transactions([random_update_transaction])
      ids = T.cast(api_call, T::Hash[Symbol, T::Array[Integer]])[:ids]

      refute_nil(ids)

      T.unsafe(ids).each do |id|
        assert_kind_of(Integer, id)
      end
    end
  end

  test "insert_transactions returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::TransactionCalls.any_instance.stubs(:post).returns(response)

    api_call = LunchMoney::TransactionCalls.new.insert_transactions([random_update_transaction])

    T.unsafe(api_call).each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  private

  sig { returns(LunchMoney::UpdateTransaction) }
  def random_update_transaction
    date = Time.now.utc.strftime("%F")
    amount = rand(0.1..99.9).to_s
    payee = "Gem Remote Testing"
    notes = "Remote test at #{Time.now.utc}"
    LunchMoney::UpdateTransaction.new(date:, amount:, payee:, notes:)
  end
end
