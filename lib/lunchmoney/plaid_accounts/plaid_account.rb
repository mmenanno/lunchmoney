# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#plaid-accounts-object
  class PlaidAccount < LunchMoney::DataObject
    sig { returns(Integer) }
    attr_accessor :id

    sig { returns(String) }
    attr_accessor :date_linked,
      :name,
      :type,
      :mask,
      :institution_name,
      :status,
      :last_import,
      :balance,
      :currency,
      :balance_last_update

    sig { returns(T.nilable(String)) }
    attr_accessor :subtype

    sig { returns(T.nilable(Integer)) }
    attr_accessor :limit

    sig do
      params(
        date_linked: String,
        name: String,
        type: String,
        mask: String,
        institution_name: String,
        status: String,
        last_import: String,
        balance: String,
        currency: String,
        balance_last_update: String,
        id: Integer,
        limit: T.nilable(Integer),
        subtype: T.nilable(String),
      ).void
    end
    def initialize(date_linked:, name:, type:, mask:, institution_name:, status:, last_import:,
      balance:, currency:, balance_last_update:, id:, limit: nil, subtype: nil)
      super()
      @date_linked = date_linked
      @name = name
      @type = type
      @mask = mask
      @institution_name = institution_name
      @status = status
      @last_import = last_import
      @balance = balance
      @currency = currency
      @balance_last_update = balance_last_update
      @id = id
      @limit = limit
      @subtype = subtype
    end
  end
end
