# typed: strict
# frozen_string_literal: true

module LunchMoney
  # object used when updating a transaction https://lunchmoney.dev/#update-transaction
  class UpdateTransaction < Split
    sig { returns(T.nilable(String)) }
    attr_accessor :currency, :status, :external_id

    sig { returns(T.nilable(Integer)) }
    attr_accessor :asset_id, :recurring_id

    sig { returns(T.nilable(T::Array[T.any(String, Integer)])) }
    attr_accessor :tags

    sig do
      params(
        tags: T.nilable(T::Array[T.any(String, Integer)]),
        category_id: T.nilable(Integer),
        payee: T.nilable(String),
        amount: T.nilable(String),
        currency: T.nilable(String),
        asset_id: T.nilable(Integer),
        recurring_id: T.nilable(Integer),
        notes: T.nilable(String),
        status: T.nilable(String),
        external_id: T.nilable(String),
        date: T.nilable(String),
      ).void
    end
    def initialize(tags: nil, category_id: nil, payee: nil, amount: nil, currency: nil, asset_id: nil,
      recurring_id: nil, notes: nil, status: nil, external_id: nil, date: nil)
      super(amount:, payee:, date:, category_id:, notes:)
      @tags = tags
      @currency = currency
      @asset_id = asset_id
      @recurring_id = recurring_id
      @status = status
      @external_id = external_id
    end
  end
end
