# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Asset < LunchMoney::DataObject
    sig { returns(Integer) }
    attr_accessor :id

    sig { returns(String) }
    attr_accessor :type_name, :name, :balance, :balance_as_of, :currency, :created_at

    sig { returns(T.nilable(String)) }
    attr_accessor :subtype_name, :display_name, :closed_on, :institution_name

    sig { returns(T::Boolean) }
    attr_accessor :exclude_transactions

    sig do
      params(
        created_at: String,
        type_name: String,
        name: String,
        balance: String,
        balance_as_of: String,
        currency: String,
        exclude_transactions: T::Boolean,
        id: Integer,
        subtype_name: T.nilable(String),
        display_name: T.nilable(String),
        closed_on: T.nilable(String),
        institution_name: T.nilable(String),
      ).void
    end
    def initialize(created_at:, type_name:, name:, balance:, balance_as_of:, currency:, exclude_transactions:, id:,
      subtype_name: nil, display_name: nil, closed_on: nil, institution_name: nil)
      super()
      @created_at = created_at
      @type_name = type_name
      @name = name
      @balance = balance
      @balance_as_of = balance_as_of
      @currency = currency
      @exclude_transactions = exclude_transactions
      @id = id
      @subtype_name = subtype_name
      @display_name = display_name
      @closed_on = closed_on
      @institution_name = institution_name
    end
  end
end
