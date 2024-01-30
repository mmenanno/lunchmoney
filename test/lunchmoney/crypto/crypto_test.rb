# typed: strict
# frozen_string_literal: true

require "test_helper"

class CryptoTest < ActiveSupport::TestCase
  test "source can be set to known valid types" do
    LunchMoney::CryptoBase::VALID_SOURCES.each do |source|
      assert_nothing_raised do
        create_crypto(source:)
      end
    end
  end

  test "source can not be set in an invalid type" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      create_crypto(source: "invalid_source")
    end

    assert_match(/is invalid, must be one of/, error.message)
  end

  test "balance_as_of can be set to a valid timestamp" do
    assert_nothing_raised do
      create_crypto(balance_as_of: "2023-01-01T01:01:01.000Z")
    end
  end

  test "balance_as_of can not be set to an invalid timestamp" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      create_crypto(balance_as_of: "2023-01-01")
    end

    assert_match(/is not a valid ISO 8601 string/, error.message)
  end

  test "created_at can be set to a valid timestamp" do
    assert_nothing_raised do
      create_crypto(created_at: "2023-01-01T01:01:01.000Z")
    end
  end

  test "created_at can not be set to an invalid timestamp" do
    error = assert_raises(LunchMoney::InvalidObjectAttribute) do
      create_crypto(created_at: "2023-01-01")
    end

    assert_match(/is not a valid ISO 8601 string/, error.message)
  end

  private

  sig do
    params(
      source: String,
      balance_as_of: String,
      status: String,
      created_at: String,
    ).returns(LunchMoney::Crypto)
  end
  def create_crypto(source: "manual", balance_as_of: "2023-01-01T01:01:01.000Z", status: "active",
    created_at: "2023-01-01T01:01:01.000Z")
    LunchMoney::Crypto.new(
      "id": 1,
      "source": source,
      "name": "Crypto Account",
      "display_name": nil,
      "balance": "1.902383849000000000",
      "balance_as_of": balance_as_of,
      "currency": "doge",
      "institution_name": nil,
      "status": status,
      "created_at": created_at,
    )
  end
end
