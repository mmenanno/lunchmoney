# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#crypto-object
  class Crypto < LunchMoney::DataObject
    include LunchMoney::Validators

    sig { returns(T.nilable(Integer)) }
    attr_accessor :id, :zabo_account_id

    sig { returns(String) }
    attr_reader :source, :balance_as_of, :created_at

    sig { returns(String) }
    attr_accessor :name, :balance, :currency, :status

    sig { returns(T.nilable(String)) }
    attr_accessor :display_name, :institution_name

    # Valid crypto source types
    VALID_SOURCES = T.let(
      [
        "synced",
        "manual",
      ],
      T::Array[String],
    )

    sig do
      params(
        created_at: String,
        source: String,
        name: String,
        balance: String,
        balance_as_of: String,
        currency: String,
        status: String,
        institution_name: T.nilable(String),
        id: T.nilable(Integer),
        zabo_account_id: T.nilable(Integer),
        display_name: T.nilable(String),
      ).void
    end
    def initialize(created_at:, source:, name:, balance:, balance_as_of:, currency:,
      status:, institution_name: nil, id: nil, zabo_account_id: nil, display_name: nil)
      super()
      @created_at = T.let(validate_iso8601!(created_at), String)
      @source = T.let(validate_one_of!(source, VALID_SOURCES), String)
      @name = name
      @balance = balance
      @balance_as_of = T.let(validate_iso8601!(balance_as_of), String)
      @currency = currency
      @status = status
      @institution_name = institution_name
      @id = id
      @zabo_account_id = zabo_account_id
      @display_name = display_name
    end

    sig { params(name: String).void }
    def source=(name)
      @source = validate_one_of!(name, VALID_SOURCES)
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
