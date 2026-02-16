# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class CryptoTest < ActiveSupport::TestCase
      include MockResponseHelper

      test "crypto returns an array of Crypto objects on success response" do
        api_call = LunchMoney::Calls::Crypto.new.crypto

        api_call.each do |crypto|
          assert_kind_of(LunchMoney::Objects::Crypto, crypto)
        end
      end

      test "crypto returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Crypto.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Crypto.new.crypto

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "update_crypto returns a Crypto objects on success response" do
        api_call = LunchMoney::Calls::Crypto.new.update_crypto(7638, balance: "2.000000000000000000")

        assert_kind_of(LunchMoney::Objects::CryptoBase, api_call)
      end

      test "update_crypto returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Crypto.any_instance.stubs(:put).returns(response)

        api_call = LunchMoney::Calls::Crypto.new.update_crypto(7638, balance: "1.000000000000000000")

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
