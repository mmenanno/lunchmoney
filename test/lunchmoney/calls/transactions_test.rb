# typed: strict
# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class TransactionsTest < ActiveSupport::TestCase
      include MockResponseHelper
      include VcrHelper

      test "transactions returns an array of Transaction objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("transactions/transactions_success") do
            api_call = LunchMoney::Calls::Transactions.new.transactions(
              start_date: "2019-01-01",
              end_date: "2025-01-01",
            )

            api_call.each do |transaction|
              assert_kind_of(LunchMoney::Objects::Transaction, transaction)
            end
          end
        end
      end

      test "transactions returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Transactions.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Transactions.new.transactions(start_date: "2019-01-01", end_date: "2025-01-01")

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "transaction returns a Transaction objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("transactions/transaction_success") do
            api_call = LunchMoney::Calls::Transactions.new.transaction(893631800)

            assert_kind_of(LunchMoney::Objects::Transaction, api_call)
          end
        end
      end

      test "transaction returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Transactions.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Transactions.new.transaction(893631800)

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "transaction_group returns a Transaction objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("transactions/transaction_group_success") do
            api_call = LunchMoney::Calls::Transactions.new.transaction_group(894063595)

            assert_kind_of(LunchMoney::Objects::Transaction, api_call)
          end
        end
      end

      test "transaction_group returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Transactions.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Transactions.new.transaction_group(893631800)

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "insert_transactions returns a hash containing an array of ids on success response" do
        VCR.use_cassette("transactions/insert_transactions_success") do
          api_call = LunchMoney::Calls::Transactions.new.insert_transactions([random_update_transaction])

          refute_nil(api_call[:ids])

          api_call[:ids].each do |id|
            assert_kind_of(Integer, id)
          end
        end
      end

      test "insert_transactions returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Transactions.any_instance.stubs(:post).returns(response)

        api_call = LunchMoney::Calls::Transactions.new.insert_transactions([random_update_transaction])

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "update_transaction returns a hash containing an updated boolean on success response" do
        with_real_ci_connections do
          VCR.use_cassette("transactions/update_transactions_success") do
            api_call = LunchMoney::Calls::Transactions.new.update_transaction(
              897349559,
              transaction: random_update_transaction(status: "cleared"),
            )

            assert(api_call[:updated])
          end
        end
      end

      test "update_transaction returns a hash containing an updated boolean and split ids on success split response" do
        VCR.use_cassette("transactions/update_transactions_split_success") do
          split = [
            LunchMoney::Objects::Split.new(amount: "10.00"),
            LunchMoney::Objects::Split.new(amount: "47.54"),
          ]
          api_call = LunchMoney::Calls::Transactions.new.update_transaction(904778058, split:)

          assert(api_call[:updated])

          api_call[:split].each do |split_id|
            assert_kind_of(Integer, split_id)
          end
        end
      end

      test "update_transaction raises an exception if neither a transaction or split were provided" do
        assert_raises(LunchMoney::MissingArgument) do
          LunchMoney::Calls::Transactions.new.update_transaction(897349559)
        end
      end

      test "update_transaction returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Transactions.any_instance.stubs(:put).returns(response)

        api_call = LunchMoney::Calls::Transactions.new.update_transaction(
          897349559,
          transaction: random_update_transaction(status: "cleared"),
        )

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "unsplit_transaction returns an array of unsplit transaction ids on success response" do
        VCR.use_cassette("transactions/unsplit_transaction_success") do
          api_call = LunchMoney::Calls::Transactions.new.unsplit_transaction([904778058])

          api_call.each do |transaction_id|
            assert_kind_of(Integer, transaction_id)
          end
        end
      end

      test "unsplit_transaction returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Transactions.any_instance.stubs(:post).returns(response)

        api_call = LunchMoney::Calls::Transactions.new.unsplit_transaction([904778058])

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "create_transaction_group returns a transaction id of the created group on success response" do
        VCR.use_cassette("transactions/create_transaction_group_success") do
          arguments = {
            date: "2024-01-30",
            payee: "Group Transaction",
            transactions: [898357857, 898359936],
          }
          api_call = LunchMoney::Calls::Transactions.new.create_transaction_group(**arguments)

          assert_kind_of(Integer, api_call)
        end
      end

      test "create_transaction_group returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Transactions.any_instance.stubs(:post).returns(response)
        arguments = {
          date: "2024-01-30",
          payee: "Group Transaction",
          transactions: [898357857, 898359936],
        }

        api_call = LunchMoney::Calls::Transactions.new.create_transaction_group(**arguments)

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "delete_transaction_group returns an array of transaction ids from the deleted group on success response" do
        VCR.use_cassette("transactions/delete_transaction_group_success") do
          api_call = LunchMoney::Calls::Transactions.new.delete_transaction_group(905483362)

          api_call[:transactions].each do |transaction_id|
            assert_kind_of(Integer, transaction_id)
          end
        end
      end

      test "delete_transaction_group returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Transactions.any_instance.stubs(:delete).returns(response)

        api_call = LunchMoney::Calls::Transactions.new.delete_transaction_group(905483362)

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      private

      sig { params(status: String).returns(LunchMoney::Objects::UpdateTransaction) }
      def random_update_transaction(status: "uncleared")
        date = Time.now.utc.strftime("%F")
        amount = rand(0.1..99.9).to_s
        payee = "Gem Remote Testing"
        notes = "Remote test at #{Time.now.utc}"
        currency = "cad"
        LunchMoney::Objects::UpdateTransaction.new(date:, amount:, payee:, notes:, currency:, status:)
      end
    end
  end
end
