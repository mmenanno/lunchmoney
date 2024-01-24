# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#crypto-object
  class Crypto < LunchMoney::DataObject
    sig { returns(T.nilable(Integer)) }
    attr_accessor :id, :zabo_account_id

    sig { returns(String) }
    attr_accessor :source, :name, :balance, :balance_as_of, :currency, :status, :institution_name, :created_at

    sig { returns(T.nilable(String)) }
    attr_accessor :display_name

    sig do
      params(
        created_at: String,
        source: String,
        name: String,
        balance: String,
        balance_as_of: String,
        currency: String,
        status: String,
        institution_name: String,
        id: T.nilable(Integer),
        zabo_account_id: T.nilable(Integer),
        display_name: T.nilable(String),
      ).void
    end
    def initialize(created_at:, source:, name:, balance:, balance_as_of:, currency:,
      status:, institution_name:, id: nil, zabo_account_id: nil, display_name: nil)
      super()
      @created_at = created_at
      @source = source
      @name = name
      @balance = balance
      @balance_as_of = balance_as_of
      @currency = currency
      @status = status
      @institution_name = institution_name
      @id = id
      @zabo_account_id = zabo_account_id
      @display_name = display_name
    end
  end
end
