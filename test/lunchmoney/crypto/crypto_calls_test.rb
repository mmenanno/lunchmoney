# typed: strict
# frozen_string_literal: true

require "test_helper"

class CryptoCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include VcrHelper

  test "crypto returns an array of Crypto objects on success response" do
    with_real_ci_connections do
      VCR.use_cassette("crypto/crypto_success") do
        api_call = LunchMoney::CryptoCalls.new.crypto

        api_call.each do |crypto|
          assert_kind_of(LunchMoney::Crypto, crypto)
        end
      end
    end
  end

  test "crypto returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CryptoCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::CryptoCalls.new.crypto

    api_call.each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end

  test "update_crypto returns a Crypto objects on success response" do
    VCR.use_cassette("crypto/update_crypto_success") do
      api_call = LunchMoney::CryptoCalls.new.update_crypto(7638, balance: "2.000000000000000000")

      assert_kind_of(LunchMoney::CryptoBase, api_call)
    end
  end

  test "update_crypto returns an array of Error objects on error response" do
    response = mock_faraday_lunchmoney_error_response
    LunchMoney::CryptoCalls.any_instance.stubs(:put).returns(response)

    api_call = LunchMoney::CryptoCalls.new.update_crypto(7638, balance: "1.000000000000000000")

    T.unsafe(api_call).each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end
end
