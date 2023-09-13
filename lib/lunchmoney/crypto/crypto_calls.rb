# typed: strict
# frozen_string_literal: true

require_relative "crypto"

module LunchMoney
  class CryptoCalls < ApiCall
    sig { returns(T::Array[LunchMoney::Crypto]) }
    def crypto
      response = get("crypto")

      errors(response)

      response.body[:crypto].map do |crypto|
        LunchMoney::Crypto.new(crypto)
      end
    end

    sig do
      params(
        crypto_id: Integer,
        name: T.nilable(String),
        display_name: T.nilable(String),
        institution_name: T.nilable(String),
        balance: T.nilable(Integer),
        currency: T.nilable(String),
      ).returns(LunchMoney::Crypto)
    end
    def update_crypto(crypto_id, name: nil, display_name: nil, institution_name: nil, balance: nil, currency: nil)
      params = {
        name:,
        display_name:,
        institution_name:,
        balance:,
        currency:,
      }

      response = put("assets/manual/#{crypto_id}", params)

      errors(response)

      LunchMoney::Crypto.new(response.body)
    end
  end
end
