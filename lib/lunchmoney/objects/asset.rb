# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#assets-object
    class Asset < LunchMoney::Objects::Object
      include LunchMoney::Validators

      attr_accessor :id

      attr_reader :type_name, :balance_as_of, :created_at

      attr_accessor :name, :balance, :currency

      attr_accessor :display_name, :closed_on, :institution_name, :subtype_name

      attr_accessor :exclude_transactions

      attr_accessor :to_base

      # Valid asset type names
      VALID_TYPE_NAMES = [
        "cash",
        "credit",
        "investment",
        "real estate",
        "loan",
        "vehicle",
        "cryptocurrency",
        "employee compensation",
        "other liability",
        "other asset",
        "depository",
      ].freeze

      def initialize(created_at:, type_name:, name:, balance:, balance_as_of:, currency:, exclude_transactions:, id:,
        subtype_name: nil, display_name: nil, closed_on: nil, institution_name: nil, to_base: nil)
        super()
        @created_at = validate_iso8601!(created_at)
        @type_name = validate_one_of!(type_name, VALID_TYPE_NAMES)
        @name = name
        @balance = balance
        @balance_as_of = validate_iso8601!(balance_as_of)
        @currency = currency
        @exclude_transactions = exclude_transactions
        @id = id
        @subtype_name = subtype_name
        @display_name = display_name
        @closed_on = closed_on
        @institution_name = institution_name
        @to_base = to_base
      end

      def type_name=(name)
        @type_name = validate_one_of!(name, VALID_TYPE_NAMES)
      end

      def balance_as_of=(time)
        @balance_as_of = validate_iso8601!(time)
      end

      def created_at=(time)
        @created_at = validate_iso8601!(time)
      end
    end
  end
end
