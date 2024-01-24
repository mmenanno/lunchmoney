# typed: strict
# frozen_string_literal: true

require_relative "crypto"

module LunchMoney
  # https://lunchmoney.dev/#crypto
  class CryptoCalls < ApiCall
    sig { returns(T.any(T::Array[LunchMoney::Crypto], LunchMoney::Errors)) }
    def crypto
      response = get("crypto")

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body[:crypto].map do |crypto|
        LunchMoney::Crypto.new(**crypto)
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
      ).returns(T.any(LunchMoney::Crypto, LunchMoney::Errors))
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

      api_errors = errors(response)
      return api_errors if api_errors.present?

      LunchMoney::Crypto.new(**response.body)
    end
  end
end
