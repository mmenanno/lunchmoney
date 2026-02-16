# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Objects
    class RecurringItemTest < ActiveSupport::TestCase
      test "RecurringItem can be initialized with all required parameters" do
        recurring_item = LunchMoney::Objects::RecurringItem.new(
          id: 697462,
          payee: "Test Recurring Item",
          currency: "cad",
          created_by: 7344,
          created_at: "2024-01-28T15:29:58.922Z",
          updated_at: "2024-01-28T15:29:58.922Z",
          billing_date: "2024-01-01",
          source: "manual",
          amount: "250.0000",
          cadence: "monthly",
          granularity: "month",
          date: "2025-09-03",
          is_income: false,
          exclude_from_totals: false,
        )

        assert_equal(697462, recurring_item.id)
        assert_equal("Test Recurring Item", recurring_item.payee)
        assert_equal("cad", recurring_item.currency)
        assert_equal(7344, recurring_item.created_by)
        assert_equal("2024-01-28T15:29:58.922Z", recurring_item.created_at)
        assert_equal("2024-01-28T15:29:58.922Z", recurring_item.updated_at)
      end

      test "RecurringItem has correct date and source attributes" do
        recurring_item = LunchMoney::Objects::RecurringItem.new(
          id: 697462,
          payee: "Test Recurring Item",
          currency: "cad",
          created_by: 7344,
          created_at: "2024-01-28T15:29:58.922Z",
          updated_at: "2024-01-28T15:29:58.922Z",
          billing_date: "2024-01-01",
          source: "manual",
          amount: "250.0000",
          cadence: "monthly",
          granularity: "month",
          date: "2025-09-03",
          is_income: false,
          exclude_from_totals: false,
        )

        assert_equal("2024-01-01", recurring_item.billing_date)
        assert_equal("manual", recurring_item.source)
        assert_equal("250.0000", recurring_item.amount)
        assert_equal("monthly", recurring_item.cadence)
        assert_equal("month", recurring_item.granularity)
        assert_equal("2025-09-03", recurring_item.date)
      end

      test "RecurringItem has correct boolean attributes" do
        recurring_item = LunchMoney::Objects::RecurringItem.new(
          id: 697462,
          payee: "Test Recurring Item",
          currency: "cad",
          created_by: 7344,
          created_at: "2024-01-28T15:29:58.922Z",
          updated_at: "2024-01-28T15:29:58.922Z",
          billing_date: "2024-01-01",
          source: "manual",
          amount: "250.0000",
          cadence: "monthly",
          granularity: "month",
          date: "2025-09-03",
          is_income: false,
          exclude_from_totals: false,
        )

        refute(recurring_item.is_income)
        refute(recurring_item.exclude_from_totals)
      end

      test "RecurringItem can be initialized with optional parameters" do
        recurring_item = LunchMoney::Objects::RecurringItem.new(
          id: 697462,
          payee: "Test Recurring Item",
          currency: "cad",
          created_by: 7344,
          created_at: "2024-01-28T15:29:58.922Z",
          updated_at: "2024-01-28T15:29:58.922Z",
          billing_date: "2024-01-01",
          source: "manual",
          amount: "250.0000",
          cadence: "monthly",
          granularity: "month",
          date: "2025-09-03",
          is_income: false,
          exclude_from_totals: false,
          start_date: "2023-01-01",
          end_date: nil,
          original_name: nil,
          description: nil,
          notes: nil,
          plaid_account_id: nil,
          asset_id: 92657,
          category_id: 777049,
          category_group_id: 777042,
          quantity: 1,
          to_base: 250.0,
          occurrences: { "2025-09-01" => [], "2025-10-01" => [] },
          transactions_within_range: [],
          missing_dates_within_range: ["2025-09-01"],
        )

        assert_equal("2023-01-01", recurring_item.start_date)
        assert_nil(recurring_item.end_date)
        assert_nil(recurring_item.original_name)
        assert_nil(recurring_item.description)
        assert_nil(recurring_item.notes)
        assert_nil(recurring_item.plaid_account_id)
      end

      test "RecurringItem has correct optional numeric and category attributes" do
        recurring_item = LunchMoney::Objects::RecurringItem.new(
          id: 697462,
          payee: "Test Recurring Item",
          currency: "cad",
          created_by: 7344,
          created_at: "2024-01-28T15:29:58.922Z",
          updated_at: "2024-01-28T15:29:58.922Z",
          billing_date: "2024-01-01",
          source: "manual",
          amount: "250.0000",
          cadence: "monthly",
          granularity: "month",
          date: "2025-09-03",
          is_income: false,
          exclude_from_totals: false,
          asset_id: 92657,
          category_id: 777049,
          category_group_id: 777042,
          quantity: 1,
          to_base: 250.0,
        )

        assert_equal(92657, recurring_item.asset_id)
        assert_equal(777049, recurring_item.category_id)
        assert_equal(777042, recurring_item.category_group_id)
        assert_equal(1, recurring_item.quantity)
        assert_in_delta(250.0, recurring_item.to_base)
      end

      test "RecurringItem has correct occurrence and transaction data" do
        recurring_item = LunchMoney::Objects::RecurringItem.new(
          id: 697462,
          payee: "Test Recurring Item",
          currency: "cad",
          created_by: 7344,
          created_at: "2024-01-28T15:29:58.922Z",
          updated_at: "2024-01-28T15:29:58.922Z",
          billing_date: "2024-01-01",
          source: "manual",
          amount: "250.0000",
          cadence: "monthly",
          granularity: "month",
          date: "2025-09-03",
          is_income: false,
          exclude_from_totals: false,
          occurrences: { "2025-09-01" => [], "2025-10-01" => [] },
          transactions_within_range: [],
          missing_dates_within_range: ["2025-09-01"],
        )

        assert_equal({ "2025-09-01" => [], "2025-10-01" => [] }, recurring_item.occurrences)
        assert_empty(recurring_item.transactions_within_range)
        assert_equal(["2025-09-01"], recurring_item.missing_dates_within_range)
      end

      test "RecurringItem inherits from Object" do
        recurring_item = LunchMoney::Objects::RecurringItem.new(
          id: 697462,
          payee: "Test Recurring Item",
          currency: "cad",
          created_by: 7344,
          created_at: "2024-01-28T15:29:58.922Z",
          updated_at: "2024-01-28T15:29:58.922Z",
          billing_date: "2024-01-01",
          source: "manual",
          amount: "250.0000",
          cadence: "monthly",
          granularity: "month",
          date: "2025-09-03",
          is_income: false,
          exclude_from_totals: false,
        )

        assert_kind_of(LunchMoney::Objects::Object, recurring_item)
      end
    end
  end
end
