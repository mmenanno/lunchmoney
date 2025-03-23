# typed: strict
# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#assets-object
    class Asset < LunchMoney::Objects::Object
      include LunchMoney::Validators

      sig { returns(Integer) }
      attr_accessor :id

      sig { returns(String) }
      attr_reader :type_name, :balance_as_of, :created_at

      sig { returns(String) }
      attr_accessor :name, :balance, :currency

      sig { returns(T.nilable(String)) }
      attr_accessor :display_name, :closed_on, :institution_name, :subtype_name

      sig { returns(T::Boolean) }
      attr_accessor :exclude_transactions

      sig { returns(T.nilable(Number)) }
      attr_accessor :to_base

      # Valid asset type names
      VALID_TYPE_NAMES = T.let(
        [
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
        ],
        T::Array[String],
      )

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
          to_base: T.nilable(Number),
        ).void
      end
      def initialize(created_at:, type_name:, name:, balance:, balance_as_of:, currency:, exclude_transactions:, id:,
        subtype_name: nil, display_name: nil, closed_on: nil, institution_name: nil, to_base: nil)
        super()
        @created_at = T.let(validate_iso8601!(created_at), String)
        @type_name = T.let(validate_one_of!(type_name, VALID_TYPE_NAMES), String)
        @name = name
        @balance = balance
        @balance_as_of = T.let(validate_iso8601!(balance_as_of), String)
        @currency = currency
        @exclude_transactions = exclude_transactions
        @id = id
        @subtype_name = subtype_name
        @display_name = display_name
        @closed_on = closed_on
        @institution_name = institution_name
        @to_base = to_base
      end

      sig { params(name: String).void }
      def type_name=(name)
        @type_name = validate_one_of!(name, VALID_TYPE_NAMES)
      end

      sig { params(time: String).void }
      def balance_as_of=(time)
        @balance_as_of = validate_iso8601!(time)
      end

      sig { params(time: String).void }
      def created_at=(time)
        @created_at = validate_iso8601!(time)
      end
    end
  end
end
