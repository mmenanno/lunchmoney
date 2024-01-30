# typed: strict
# frozen_string_literal: true

require "test_helper"

class TransactionCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include VcrHelper

  test "transactions returns an array of Transaction objects on success response" do
    with_real_ci_connections do
      VCR.use_cassette("transactions/transactions_success") do
        api_call = LunchMoney::TransactionCalls.new.transactions(start_date: "2019-01-01", end_date: "2025-01-01")

        api_call.each do |transaction|
          assert_kind_of(LunchMoney::Transaction, transaction)
        end
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
    with_real_ci_connections do
      VCR.use_cassette("transactions/transaction_success") do
        api_call = LunchMoney::TransactionCalls.new.transaction(893631800)

        assert_kind_of(LunchMoney::Transaction, api_call)
      end
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
    with_real_ci_connections do
      VCR.use_cassette("transactions/transaction_group_success") do
        api_call = LunchMoney::TransactionCalls.new.transaction(894063595)

        assert_kind_of(LunchMoney::Transaction, api_call)
      end
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
    with_real_ci_connections do
      VCR.use_cassette("transactions/insert_transactions_success") do
        api_call = LunchMoney::TransactionCalls.new.insert_transactions([random_update_transaction])
        ids = T.cast(api_call, T::Hash[Symbol, T::Array[Integer]])[:ids]

        refute_nil(ids)

        T.unsafe(ids).each do |id|
          assert_kind_of(Integer, id)
        end
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

  test "update_transaction returns a hash containing an updated boolean on success response" do
    with_real_ci_connections do
      VCR.use_cassette("transactions/update_transactions_success") do
        api_call = LunchMoney::TransactionCalls.new.update_transaction(
          897349559,
          transaction: random_update_transaction(status: "cleared"),
        )
        updated = T.cast(api_call, T::Hash[Symbol, T::Boolean])[:updated]

        assert(updated)
      end
    end
  end

  test "update_transaction returns a hash containing an updated boolean and split ids on success split response" do
    VCR.use_cassette("transactions/update_transactions_split_success") do
      split = [
        LunchMoney::Split.new(amount: "10.00"),
        LunchMoney::Split.new(amount: "47.54"),
      ]
      api_call = LunchMoney::TransactionCalls.new.update_transaction(904778058, split:)
      api_call = T.cast(api_call, { updated: T::Boolean, split: T.nilable(T::Array[Integer]) })

      assert(api_call[:updated])

      api_call[:split].each do |split_id|
        assert_kind_of(Integer, split_id)
      end
    end
  end

  test "update_transaction raises an exception if neither a transaction or split were provided" do
    assert_raises(LunchMoney::MissingArgument) do
      LunchMoney::TransactionCalls.new.update_transaction(897349559)
    end
  end

  test "update_transaction returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::TransactionCalls.any_instance.stubs(:put).returns(response)

    api_call = LunchMoney::TransactionCalls.new.update_transaction(
      897349559,
      transaction: random_update_transaction(status: "cleared"),
    )

    T.unsafe(api_call).each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  test "unsplit_transaction returns an array of unsplit transaction ids on success response" do
    VCR.use_cassette("transactions/unsplit_transaction_success") do
      api_call = LunchMoney::TransactionCalls.new.unsplit_transaction([904778058])

      api_call.each do |transaction_id|
        assert_kind_of(Integer, transaction_id)
      end
    end
  end

  test "unsplit_transaction returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::TransactionCalls.any_instance.stubs(:post).returns(response)

    api_call = LunchMoney::TransactionCalls.new.unsplit_transaction([904778058])

    T.unsafe(api_call).each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  private

  sig { params(status: String).returns(LunchMoney::UpdateTransaction) }
  def random_update_transaction(status: "uncleared")
    date = Time.now.utc.strftime("%F")
    amount = rand(0.1..99.9).to_s
    payee = "Gem Remote Testing"
    notes = "Remote test at #{Time.now.utc}"
    currency = "cad"
    LunchMoney::UpdateTransaction.new(date:, amount:, payee:, notes:, currency:, status:)
  end
end
