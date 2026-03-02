# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Client
    class PaginationTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @mock_client = mock("client")
      end

      test "Pagination includes Enumerable" do
        assert LunchMoney::Client::Pagination < Enumerable
      end

      test "iterates single page when has_more is false" do
        txn1 = LunchMoney::Objects::Transaction.new(id: 1, date: "2024-01-01", amount: "10.00")
        txn2 = LunchMoney::Objects::Transaction.new(id: 2, date: "2024-01-02", amount: "20.00")

        @mock_client.expects(:transactions_page)
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 0, limit: 1000)
          .returns({ transactions: [txn1, txn2], has_more: false })

        pagination = LunchMoney::Client::Pagination.new(
          client: @mock_client,
          params: { start_date: "2024-01-01", end_date: "2024-01-31" }
        )

        results = pagination.to_a
        assert_equal 2, results.size
        assert_equal 1, results.first.id
        assert_equal 2, results.last.id
      end

      test "iterates across multiple pages" do
        txn1 = LunchMoney::Objects::Transaction.new(id: 1, date: "2024-01-01", amount: "10.00")
        txn2 = LunchMoney::Objects::Transaction.new(id: 2, date: "2024-01-02", amount: "20.00")
        txn3 = LunchMoney::Objects::Transaction.new(id: 3, date: "2024-01-03", amount: "30.00")

        @mock_client.expects(:transactions_page)
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 0, limit: 1000)
          .returns({ transactions: [txn1, txn2], has_more: true })

        @mock_client.expects(:transactions_page)
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 1000, limit: 1000)
          .returns({ transactions: [txn3], has_more: false })

        pagination = LunchMoney::Client::Pagination.new(
          client: @mock_client,
          params: { start_date: "2024-01-01", end_date: "2024-01-31" }
        )

        results = pagination.to_a
        assert_equal 3, results.size
        assert_equal [1, 2, 3], results.map(&:id)
      end

      test "stops when has_more is false" do
        txn1 = LunchMoney::Objects::Transaction.new(id: 1, date: "2024-01-01", amount: "10.00")

        @mock_client.expects(:transactions_page)
          .once
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 0, limit: 1000)
          .returns({ transactions: [txn1], has_more: false })

        pagination = LunchMoney::Client::Pagination.new(
          client: @mock_client,
          params: { start_date: "2024-01-01", end_date: "2024-01-31" }
        )

        results = pagination.to_a
        assert_equal 1, results.size
      end

      test "supports lazy enumeration with first(n)" do
        txn1 = LunchMoney::Objects::Transaction.new(id: 1, date: "2024-01-01", amount: "10.00")
        txn2 = LunchMoney::Objects::Transaction.new(id: 2, date: "2024-01-02", amount: "20.00")
        txn3 = LunchMoney::Objects::Transaction.new(id: 3, date: "2024-01-03", amount: "30.00")

        @mock_client.expects(:transactions_page)
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 0, limit: 1000)
          .returns({ transactions: [txn1, txn2, txn3], has_more: true })

        pagination = LunchMoney::Client::Pagination.new(
          client: @mock_client,
          params: { start_date: "2024-01-01", end_date: "2024-01-31" }
        )

        results = pagination.lazy.first(2)
        assert_equal 2, results.size
        assert_equal [1, 2], results.map(&:id)
      end

      test "passes correct offset and limit to transactions_page" do
        txn1 = LunchMoney::Objects::Transaction.new(id: 1, date: "2024-01-01", amount: "10.00")

        @mock_client.expects(:transactions_page)
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 50, limit: 25)
          .returns({ transactions: [txn1], has_more: false })

        pagination = LunchMoney::Client::Pagination.new(
          client: @mock_client,
          params: { start_date: "2024-01-01", end_date: "2024-01-31", offset: 50, limit: 25 }
        )

        results = pagination.to_a
        assert_equal 1, results.size
      end

      test "increments offset by limit on each page" do
        txn1 = LunchMoney::Objects::Transaction.new(id: 1, date: "2024-01-01", amount: "10.00")
        txn2 = LunchMoney::Objects::Transaction.new(id: 2, date: "2024-01-02", amount: "20.00")
        txn3 = LunchMoney::Objects::Transaction.new(id: 3, date: "2024-01-03", amount: "30.00")

        call_sequence = sequence("pagination")

        @mock_client.expects(:transactions_page)
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 0, limit: 2)
          .in_sequence(call_sequence)
          .returns({ transactions: [txn1, txn2], has_more: true })

        @mock_client.expects(:transactions_page)
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 2, limit: 2)
          .in_sequence(call_sequence)
          .returns({ transactions: [txn3], has_more: false })

        pagination = LunchMoney::Client::Pagination.new(
          client: @mock_client,
          params: { start_date: "2024-01-01", end_date: "2024-01-31", limit: 2 }
        )

        results = pagination.to_a
        assert_equal 3, results.size
        assert_equal [1, 2, 3], results.map(&:id)
      end

      test "handles empty first page" do
        @mock_client.expects(:transactions_page)
          .with(start_date: "2024-01-01", end_date: "2024-01-31", offset: 0, limit: 1000)
          .returns({ transactions: [], has_more: false })

        pagination = LunchMoney::Client::Pagination.new(
          client: @mock_client,
          params: { start_date: "2024-01-01", end_date: "2024-01-31" }
        )

        results = pagination.to_a
        assert_equal [], results
      end
    end
  end
end
