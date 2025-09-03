# typed: strict
# frozen_string_literal: true

require_relative "../objects/crypto"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#crypto
    class Crypto < LunchMoney::Calls::Base
      sig { returns(T.any(T::Array[LunchMoney::Objects::Crypto], LunchMoney::Errors)) }
      def crypto
        response = get("crypto")

        handle_api_response(response) do |body|
          body[:crypto].map do |crypto|
            LunchMoney::Objects::Crypto.new(**crypto)
          end
        end
      end

      sig do
        params(
          crypto_id: Integer,
          name: T.nilable(String),
          display_name: T.nilable(String),
          institution_name: T.nilable(String),
          balance: T.nilable(String),
          currency: T.nilable(String),
        ).returns(T.any(LunchMoney::Objects::CryptoBase, LunchMoney::Errors))
      end
      def update_crypto(crypto_id, name: nil, display_name: nil, institution_name: nil, balance: nil, currency: nil)
        params = clean_params({
          name:,
          display_name:,
          institution_name:,
          balance:,
          currency:,
        })

        response = put("crypto/manual/#{crypto_id}", params)

        handle_api_response(response) do |body|
          LunchMoney::Objects::CryptoBase.new(**body)
        end
      end
    end
  end
end
