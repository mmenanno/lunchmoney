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
end
