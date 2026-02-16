# frozen_string_literal: true

require "test_helper"
require_relative "../../../lib/lunchmoney/objects/summarized_transaction"

module LunchMoney
  module Objects
    class SummarizedTransactionTest < ActiveSupport::TestCase
      test "SummarizedTransaction can be initialized with all required parameters" do
        transaction = LunchMoney::Objects::SummarizedTransaction.new(
          id: 123456,
          date: "2024-01-01",
          amount: "100.0000",
          currency: "usd",
          payee: "Test Summarized Transaction",
          category_id: 777049,
          recurring_id: 697462,
        )

        assert_equal(123456, transaction.id)
        assert_equal("2024-01-01", transaction.date)
        assert_equal("100.0000", transaction.amount)
        assert_equal("usd", transaction.currency)
        assert_equal("Test Summarized Transaction", transaction.payee)
        assert_equal(777049, transaction.category_id)
      end

      test "SummarizedTransaction has correct recurring_id" do
        transaction = LunchMoney::Objects::SummarizedTransaction.new(
          id: 123456,
          date: "2024-01-01",
          amount: "100.0000",
          currency: "usd",
          payee: "Test Summarized Transaction",
          category_id: 777049,
          recurring_id: 697462,
        )

        assert_equal(697462, transaction.recurring_id)
      end

      test "SummarizedTransaction can be initialized with optional parameters" do
        transaction = LunchMoney::Objects::SummarizedTransaction.new(
          id: 123456,
          date: "2024-02-01",
          amount: "50.0000",
          currency: "cad",
          payee: "Test Transaction",
          category_id: 666,
          recurring_id: 555,
          to_base: 0.75,
        )

        assert_equal(123456, transaction.id)
        assert_equal("2024-02-01", transaction.date)
        assert_equal("50.0000", transaction.amount)
        assert_equal("cad", transaction.currency)
        assert_equal("Test Transaction", transaction.payee)
        assert_equal(666, transaction.category_id)
      end

      test "SummarizedTransaction has correct to_base value" do
        transaction = LunchMoney::Objects::SummarizedTransaction.new(
          id: 123456,
          date: "2024-02-01",
          amount: "50.0000",
          currency: "cad",
          payee: "Test Transaction",
          category_id: 666,
          recurring_id: 555,
          to_base: 0.75,
        )

        assert_equal(555, transaction.recurring_id)
        assert_in_delta(0.75, transaction.to_base)
      end

      test "SummarizedTransaction inherits from Object" do
        transaction = LunchMoney::Objects::SummarizedTransaction.new(
          id: 123456,
          date: "2024-01-01",
          amount: "100.0000",
          currency: "usd",
          payee: "Test Transaction",
          category_id: 777049,
          recurring_id: 697462,
        )

        assert_kind_of(LunchMoney::Objects::Object, transaction)
      end
    end
  end
end
