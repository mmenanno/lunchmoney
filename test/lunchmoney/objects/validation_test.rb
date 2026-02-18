# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Objects
    class ValidationTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      # --- InsertTransaction ---

      test "InsertTransaction validates date is required" do
        txn = LunchMoney::Objects::InsertTransaction.new(amount: "10.00")

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/date is required/, error.message)
      end

      test "InsertTransaction validates amount is required" do
        txn = LunchMoney::Objects::InsertTransaction.new(date: "2024-01-01")

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/amount is required/, error.message)
      end

      test "InsertTransaction validates payee maxLength of 140" do
        txn = LunchMoney::Objects::InsertTransaction.new(
          date: "2024-01-01", amount: "10.00", payee: "x" * 141
        )

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/payee/, error.message)
      end

      test "InsertTransaction validates original_name maxLength of 140" do
        txn = LunchMoney::Objects::InsertTransaction.new(
          date: "2024-01-01", amount: "10.00", original_name: "x" * 141
        )

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/original_name/, error.message)
      end

      test "InsertTransaction validates notes maxLength of 350" do
        txn = LunchMoney::Objects::InsertTransaction.new(
          date: "2024-01-01", amount: "10.00", notes: "x" * 351
        )

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/notes/, error.message)
      end

      test "InsertTransaction validates external_id maxLength of 75" do
        txn = LunchMoney::Objects::InsertTransaction.new(
          date: "2024-01-01", amount: "10.00", external_id: "x" * 76
        )

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/external_id/, error.message)
      end

      test "InsertTransaction validates status enum" do
        txn = LunchMoney::Objects::InsertTransaction.new(
          date: "2024-01-01", amount: "10.00", status: "invalid_status"
        )

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/status/, error.message)
      end

      test "InsertTransaction accepts valid status values" do
        %w[reviewed unreviewed].each do |valid_status|
          txn = LunchMoney::Objects::InsertTransaction.new(
            date: "2024-01-01", amount: "10.00", status: valid_status
          )
          assert_nothing_raised { txn.validate! }
        end
      end

      test "InsertTransaction validates custom_metadata must be a Hash" do
        txn = LunchMoney::Objects::InsertTransaction.new(
          date: "2024-01-01", amount: "10.00", custom_metadata: "not_a_hash"
        )

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/custom_metadata must be a Hash/, error.message)
      end

      test "InsertTransaction validates custom_metadata size limit of 4096" do
        large_metadata = { data: "x" * 5000 }
        txn = LunchMoney::Objects::InsertTransaction.new(
          date: "2024-01-01", amount: "10.00", custom_metadata: large_metadata
        )

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/custom_metadata exceeds 4096/, error.message)
      end

      test "InsertTransaction passes validation with valid data" do
        txn = LunchMoney::Objects::InsertTransaction.new(
          date: "2024-01-01",
          amount: "25.50",
          payee: "Coffee Shop",
          notes: "Morning latte",
          status: "reviewed",
          external_id: "ext-123",
          custom_metadata: { source: "import" }
        )

        assert_nothing_raised { txn.validate! }
      end

      test "InsertTransaction passes validation with only required fields" do
        txn = LunchMoney::Objects::InsertTransaction.new(date: "2024-01-01", amount: "10.00")

        assert_nothing_raised { txn.validate! }
      end

      # --- UpdateTransaction ---

      test "UpdateTransaction validates payee maxLength of 140" do
        txn = LunchMoney::Objects::UpdateTransaction.new(payee: "x" * 141)

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/payee/, error.message)
      end

      test "UpdateTransaction validates original_name maxLength of 140" do
        txn = LunchMoney::Objects::UpdateTransaction.new(original_name: "x" * 141)

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/original_name/, error.message)
      end

      test "UpdateTransaction validates notes maxLength of 350" do
        txn = LunchMoney::Objects::UpdateTransaction.new(notes: "x" * 351)

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/notes/, error.message)
      end

      test "UpdateTransaction validates external_id maxLength of 75" do
        txn = LunchMoney::Objects::UpdateTransaction.new(external_id: "x" * 76)

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/external_id/, error.message)
      end

      test "UpdateTransaction validates status enum" do
        txn = LunchMoney::Objects::UpdateTransaction.new(status: "bad_status")

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/status/, error.message)
      end

      test "UpdateTransaction validates source enum" do
        txn = LunchMoney::Objects::UpdateTransaction.new(source: "invalid_source")

        error = assert_raises(LunchMoney::ClientValidationError) { txn.validate! }
        assert_match(/source/, error.message)
      end

      test "UpdateTransaction passes validation with no fields set" do
        txn = LunchMoney::Objects::UpdateTransaction.new

        assert_nothing_raised { txn.validate! }
      end

      test "UpdateTransaction passes validation with valid fields" do
        txn = LunchMoney::Objects::UpdateTransaction.new(
          payee: "Updated Payee",
          notes: "Updated notes",
          status: "reviewed",
          source: "api"
        )

        assert_nothing_raised { txn.validate! }
      end

      # --- CreateManualAccount ---

      test "CreateManualAccount validates name is required" do
        account = LunchMoney::Objects::CreateManualAccount.new(type: "checking", balance: "100.00")

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/name is required/, error.message)
      end

      test "CreateManualAccount validates type is required" do
        account = LunchMoney::Objects::CreateManualAccount.new(name: "Savings", balance: "100.00")

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/type is required/, error.message)
      end

      test "CreateManualAccount validates balance is required" do
        account = LunchMoney::Objects::CreateManualAccount.new(name: "Savings", type: "checking")

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/balance is required/, error.message)
      end

      test "CreateManualAccount validates name maxLength of 45" do
        account = LunchMoney::Objects::CreateManualAccount.new(
          name: "x" * 46, type: "checking", balance: "100.00"
        )

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/name must be at most 45/, error.message)
      end

      test "CreateManualAccount validates name minLength of 1" do
        account = LunchMoney::Objects::CreateManualAccount.new(
          name: "", type: "checking", balance: "100.00"
        )

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/name must be at least 1/, error.message)
      end

      test "CreateManualAccount validates institution_name maxLength of 50" do
        account = LunchMoney::Objects::CreateManualAccount.new(
          name: "Savings", type: "checking", balance: "100.00",
          institution_name: "x" * 51
        )

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/institution_name must be at most 50/, error.message)
      end

      test "CreateManualAccount validates institution_name minLength of 1" do
        account = LunchMoney::Objects::CreateManualAccount.new(
          name: "Savings", type: "checking", balance: "100.00",
          institution_name: ""
        )

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/institution_name must be at least 1/, error.message)
      end

      test "CreateManualAccount validates subtype maxLength of 100" do
        account = LunchMoney::Objects::CreateManualAccount.new(
          name: "Savings", type: "checking", balance: "100.00",
          subtype: "x" * 101
        )

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/subtype must be at most 100/, error.message)
      end

      test "CreateManualAccount validates subtype minLength of 1" do
        account = LunchMoney::Objects::CreateManualAccount.new(
          name: "Savings", type: "checking", balance: "100.00",
          subtype: ""
        )

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/subtype must be at least 1/, error.message)
      end

      test "CreateManualAccount validates status enum" do
        account = LunchMoney::Objects::CreateManualAccount.new(
          name: "Savings", type: "checking", balance: "100.00",
          status: "invalid"
        )

        error = assert_raises(LunchMoney::ClientValidationError) { account.validate! }
        assert_match(/status must be one of: active, closed/, error.message)
      end

      test "CreateManualAccount passes validation with valid data" do
        account = LunchMoney::Objects::CreateManualAccount.new(
          name: "Savings Account",
          type: "checking",
          balance: "5000.00",
          institution_name: "My Bank",
          subtype: "savings",
          status: "active"
        )

        assert_nothing_raised { account.validate! }
      end

      # --- SplitTransaction ---

      test "SplitTransaction validates amount is required" do
        split = LunchMoney::Objects::SplitTransaction.new(payee: "Partial")

        error = assert_raises(LunchMoney::ClientValidationError) { split.validate! }
        assert_match(/amount is required/, error.message)
      end

      test "SplitTransaction validates payee maxLength of 140" do
        split = LunchMoney::Objects::SplitTransaction.new(
          amount: "5.00", payee: "x" * 141
        )

        error = assert_raises(LunchMoney::ClientValidationError) { split.validate! }
        assert_match(/payee/, error.message)
      end

      test "SplitTransaction validates notes maxLength of 350" do
        split = LunchMoney::Objects::SplitTransaction.new(
          amount: "5.00", notes: "x" * 351
        )

        error = assert_raises(LunchMoney::ClientValidationError) { split.validate! }
        assert_match(/notes/, error.message)
      end

      test "SplitTransaction passes validation with valid data" do
        split = LunchMoney::Objects::SplitTransaction.new(
          amount: "15.00",
          payee: "Split item",
          notes: "Half of the bill"
        )

        assert_nothing_raised { split.validate! }
      end

      test "SplitTransaction passes validation with only required amount" do
        split = LunchMoney::Objects::SplitTransaction.new(amount: "10.00")

        assert_nothing_raised { split.validate! }
      end
    end
  end
end
