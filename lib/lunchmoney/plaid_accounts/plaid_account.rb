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
      :balance,
      :currency,
      :balance_last_update,
      :display_name,
      :plaid_last_successful_update

    sig { returns(T.nilable(String)) }
    attr_accessor :subtype, :import_start_date, :last_fetch, :last_import

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
        balance: String,
        currency: String,
        balance_last_update: String,
        display_name: String,
        id: Integer,
        plaid_last_successful_update: String,
        last_import: T.nilable(String),
        limit: T.nilable(Integer),
        subtype: T.nilable(String),
        import_start_date: T.nilable(String),
        last_fetch: T.nilable(String),
      ).void
    end
    def initialize(date_linked:, name:, type:, mask:, institution_name:, status:, balance:, currency:,
      balance_last_update:, display_name:, id:, plaid_last_successful_update:, last_import: nil, limit: nil,
      subtype: nil, import_start_date: nil, last_fetch: nil)
      super()
      @id = id
      @date_linked = date_linked
      @name = name
      @display_name = display_name
      @type = type
      @subtype = subtype
      @mask = mask
      @institution_name = institution_name
      @status = status
      @limit = limit
      @balance = balance
      @currency = currency
      @balance_last_update = balance_last_update
      @import_start_date = import_start_date
      @last_import = last_import
      @last_fetch = last_fetch
      @plaid_last_successful_update = plaid_last_successful_update
    end
  end
end
