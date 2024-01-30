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
end
