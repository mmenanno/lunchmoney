# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#transaction-object
  class Transaction < LunchMoney::DataObject
    sig { returns(T.nilable(Integer)) }
    attr_accessor :id, :to_base, :category_id, :recurring_id, :asset_id, :plaid_account_id, :parent_id, :group_id

    sig { returns(T.nilable(String)) }
    attr_accessor :date,
      :payee,
      :amount,
      :currency,
      :notes,
      :status,
      :external_id,
      :original_name,
      :type,
      :subtype,
      :fees,
      :price,
      :quantity

    sig { returns(T.nilable(T::Boolean)) }
    attr_accessor :is_group

    sig { returns(T.nilable(T::Array[LunchMoney::Tag])) }
    attr_accessor :tags

    sig do
      params(
        quantity: T.nilable(String),
        date: T.nilable(String),
        payee: T.nilable(String),
        amount: T.nilable(String),
        currency: T.nilable(String),
        to_base: T.nilable(Integer),
        notes: T.nilable(String),
        category_id: T.nilable(Integer),
        recurring_id: T.nilable(Integer),
        asset_id: T.nilable(Integer),
        plaid_account_id: T.nilable(Integer),
        status: T.nilable(String),
        parent_id: T.nilable(Integer),
        is_group: T.nilable(T::Boolean),
        group_id: T.nilable(Integer),
        tags: T.nilable(T::Array[LunchMoney::Tag]),
        external_id: T.nilable(String),
        original_name: T.nilable(String),
        type: T.nilable(String),
        subtype: T.nilable(String),
        fees: T.nilable(String),
        price: T.nilable(String),
        id: T.nilable(Integer),
      ).void
    end
    def initialize(quantity: nil, date: nil, payee: nil, amount: nil, currency: nil, to_base: nil, notes: nil,
      category_id: nil, recurring_id: nil, asset_id: nil, plaid_account_id: nil, status: nil, parent_id: nil,
      is_group: nil, group_id: nil, tags: nil, external_id: nil, original_name: nil, type: nil, subtype: nil,
      fees: nil, price: nil, id: nil)
      super()
      @quantity = quantity
      @date = date
      @payee = payee
      @amount = amount
      @currency = currency
      @to_base = to_base
      @notes = notes
      @category_id = category_id
      @recurring_id = recurring_id
      @asset_id = asset_id
      @plaid_account_id = plaid_account_id
      @status = status
      @parent_id = parent_id
      @is_group = is_group
      @group_id = group_id
      @tags = tags
      @external_id = external_id
      @original_name = original_name
      @type = type
      @subtype = subtype
      @fees = fees
      @price = price
      @id = id
    end
  end
end
