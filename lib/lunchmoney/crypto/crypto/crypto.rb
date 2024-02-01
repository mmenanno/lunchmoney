# typed: strict
# frozen_string_literal: true

require_relative "crypto_base"
module LunchMoney
  # https://lunchmoney.dev/#crypto-object
  class Crypto < CryptoBase
    include LunchMoney::Validators

    sig { returns(String) }
    attr_reader :balance_as_of

    sig { returns(String) }
    attr_accessor :currency, :status

    sig do
      params(
        created_at: String,
        source: String,
        name: String,
        balance: String,
        balance_as_of: String,
        currency: String,
        status: String,
        institution_name: T.nilable(String),
        id: T.nilable(Integer),
        zabo_account_id: T.nilable(Integer),
        display_name: T.nilable(String),
      ).void
    end
    def initialize(created_at:, source:, name:, balance:, balance_as_of:, currency:,
      status:, institution_name: nil, id: nil, zabo_account_id: nil, display_name: nil)
      super(created_at:, source:, name:, balance:, institution_name:, id:, zabo_account_id:, display_name:)
      @balance_as_of = T.let(validate_iso8601!(balance_as_of), String)
      @currency = currency
      @status = status
    end

    sig { params(time: String).void }
    def balance_as_of=(time)
      @balance_as_of = validate_iso8601!(time)
    end
  end
end
