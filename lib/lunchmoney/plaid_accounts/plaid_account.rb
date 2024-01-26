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
      :balance_last_update,
      :display_name,
      :plaid_last_successful_update

    sig { returns(T.nilable(String)) }
    attr_accessor :subtype, :import_start_date, :last_fetch

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
        display_name: String,
        id: Integer,
        plaid_last_successful_update: String,
        limit: T.nilable(Integer),
        subtype: T.nilable(String),
        import_start_date: T.nilable(String),
        last_fetch: T.nilable(String),
      ).void
    end
    def initialize(date_linked:, name:, type:, mask:, institution_name:, status:, last_import:, balance:, currency:,
      balance_last_update:, display_name:, id:, plaid_last_successful_update:, limit: nil, subtype: nil,
      import_start_date: nil, last_fetch: nil)
      super()
      @date_linked = date_linked
      @name = name
      @display_name = display_name
      @type = type
      @mask = mask
      @institution_name = institution_name
      @status = status
      @last_import = last_import
      @balance = balance
      @currency = currency
      @balance_last_update = balance_last_update
      @id = id
      @plaid_last_successful_update = plaid_last_successful_update
      @limit = limit
      @subtype = subtype
      @balance_last_update = balance_last_update
      @import_start_date = import_start_date
      @last_fetch = last_fetch
    end
  end
end
