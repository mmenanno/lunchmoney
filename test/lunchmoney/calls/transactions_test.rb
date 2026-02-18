# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class TransactionsTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      # --- transactions_page ---

      test "transactions_page returns hash with transactions array and has_more" do
        stub_lunchmoney(:get, "/transactions?end_date=2024-07-31&limit=1000&offset=0&start_date=2024-07-01",
          response: "transactions/list_default_response")

        result = @api.transactions_page(start_date: "2024-07-01", end_date: "2024-07-31")

        assert_kind_of Hash, result
        assert_kind_of Array, result[:transactions]
        assert_equal 4, result[:transactions].length
        assert_equal false, result[:has_more]
      end

      test "transactions_page returns Transaction objects" do
        stub_lunchmoney(:get, "/transactions?end_date=2024-07-31&limit=1000&offset=0&start_date=2024-07-01",
          response: "transactions/list_default_response")

        result = @api.transactions_page(start_date: "2024-07-01", end_date: "2024-07-31")

        result[:transactions].each do |txn|
          assert_kind_of LunchMoney::Objects::Transaction, txn
        end
        assert_equal 2112150655, result[:transactions].first.id
        assert_equal "Paycheck", result[:transactions].first.payee
      end

      # --- transactions (pagination) ---

      test "transactions returns a Pagination object that is Enumerable" do
        result = @api.transactions(start_date: "2024-07-01", end_date: "2024-07-31")

        assert_kind_of LunchMoney::Client::Pagination, result
        assert_kind_of Enumerable, result
      end

      test "transactions.to_a fetches all pages and returns Transaction objects" do
        stub_lunchmoney(:get, "/transactions?end_date=2024-07-31&limit=1000&offset=0&start_date=2024-07-01",
          response: "transactions/list_default_response")

        result = @api.transactions(start_date: "2024-07-01", end_date: "2024-07-31").to_a

        assert_kind_of Array, result
        assert_equal 4, result.length
        result.each do |txn|
          assert_kind_of LunchMoney::Objects::Transaction, txn
        end
      end

      # --- transaction (single) ---

      test "transaction returns a single Transaction" do
        stub_lunchmoney(:get, "/transactions/2112150654", response: "transactions/get_basic_transaction")

        result = @api.transaction(2112150654)

        assert_kind_of LunchMoney::Objects::Transaction, result
        assert_equal 2112150654, result.id
        assert_equal "Noodle House", result.payee
        assert_equal "21.9800", result.amount
      end

      test "transaction raises NotFoundError on 404" do
        stub_lunchmoney_error(:get, "/transactions/999999", status: 404, message: "Transaction not found")

        assert_raises(LunchMoney::NotFoundError) do
          @api.transaction(999999)
        end
      end

      # --- create_transaction ---

      test "create_transaction returns created Transaction" do
        stub_lunchmoney(:post, "/transactions", response: "transactions/create_bare_minimum_request")

        result = @api.create_transaction(date: "2024-11-01", amount: "99.99")

        assert_kind_of LunchMoney::Objects::Transaction, result
        assert_equal 123456789, result.id
        assert_equal "99.99", result.amount
      end

      test "create_transaction raises ClientValidationError for missing date" do
        assert_raises(LunchMoney::ClientValidationError) do
          @api.create_transaction(amount: "50.00")
        end
      end

      test "create_transaction raises ClientValidationError for missing amount" do
        assert_raises(LunchMoney::ClientValidationError) do
          @api.create_transaction(date: "2024-11-01")
        end
      end

      # --- create_transactions ---

      test "create_transactions returns InsertTransactionsResponse" do
        stub_lunchmoney(:post, "/transactions", response: "transactions/create_two_new_cash_transactions")

        result = @api.create_transactions([
          { date: "2024-11-01", amount: "15.00", payee: "Lunch with James", notes: "Cash Transaction" },
          { date: "2024-11-01", amount: "-9.99", payee: "me", notes: "Interest from Investment Account Cash" },
        ])

        assert_kind_of LunchMoney::Objects::InsertTransactionsResponse, result
      end

      # --- update_transaction ---

      test "update_transaction returns updated Transaction" do
        stub_lunchmoney(:put, "/transactions/2112140361",
          response: "transactions/update_transaction_with_updated_category")

        result = @api.update_transaction(2112140361, category_id: 315162)

        assert_kind_of LunchMoney::Objects::Transaction, result
        assert_equal 2112140361, result.id
        assert_equal 315162, result.category_id
      end

      # --- delete_transaction ---

      test "delete_transaction returns nil on 204" do
        stub_lunchmoney(:delete, "/transactions/123", status: 204, body: nil)

        result = @api.delete_transaction(123)

        assert_nil result
      end
    end
  end
end
