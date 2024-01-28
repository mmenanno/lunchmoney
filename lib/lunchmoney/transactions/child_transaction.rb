# typed: strict
# frozen_string_literal: true

module LunchMoney
  # Slimmed down version of https://lunchmoney.dev/#transaction-object used in the
  # `children` field of a transaction object
  class ChildTransaction < LunchMoney::DataObject
    sig { returns(Integer) }
    attr_accessor :id

    sig { returns(T.any(Integer, Float)) }
    attr_accessor :to_base

    sig { returns(T.nilable(Integer)) }
    attr_accessor :asset_id, :plaid_account_id

    sig { returns(String) }
    attr_accessor :date,
      :amount,
      :currency,
      :payee,
      :formatted_date

    sig { returns(T.nilable(String)) }
    attr_accessor :notes

    sig do
      params(
        id: Integer,
        date: String,
        amount: String,
        currency: String,
        to_base: T.any(Integer, Float),
        payee: String,
        formatted_date: String,
        notes: T.nilable(String),
        asset_id: T.nilable(Integer),
        plaid_account_id: T.nilable(Integer),
      ).void
    end
    def initialize(id:, date:, amount:, currency:, to_base:, payee:, formatted_date:, notes: nil, asset_id: nil,
      plaid_account_id: nil)
      super()
      @id = id
      @date = date
      @amount = amount
      @currency = currency
      @to_base = to_base
      @payee = payee
      @notes = notes
      @asset_id = asset_id
      @plaid_account_id = plaid_account_id
      @formatted_date = formatted_date
    end
  end
end
