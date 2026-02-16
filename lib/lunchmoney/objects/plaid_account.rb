# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#plaid-accounts-object
    class PlaidAccount < LunchMoney::Objects::Object
      attr_accessor :id

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

      attr_accessor :subtype, :import_start_date, :last_fetch, :last_import

      attr_accessor :limit

      attr_accessor :to_base

      def initialize(date_linked:, name:, type:, mask:, institution_name:, status:, balance:, currency:,
        balance_last_update:, display_name:, id:, plaid_last_successful_update:, last_import: nil, limit: nil,
        subtype: nil, import_start_date: nil, last_fetch: nil, to_base: nil)
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
        @to_base = to_base
      end
    end
  end
end
