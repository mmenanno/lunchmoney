# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#crypto-object
  class CryptoBase < LunchMoney::DataObject
    include LunchMoney::Validators

    sig { returns(T.nilable(Integer)) }
    attr_accessor :id, :zabo_account_id

    sig { returns(String) }
    attr_reader :source, :created_at

    sig { returns(String) }
    attr_accessor :name, :balance

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
        institution_name: T.nilable(String),
        id: T.nilable(Integer),
        zabo_account_id: T.nilable(Integer),
        display_name: T.nilable(String),
      ).void
    end
    def initialize(created_at:, source:, name:, balance:, institution_name: nil, id: nil, zabo_account_id: nil,
      display_name: nil)
      super()
      @created_at = T.let(validate_iso8601!(created_at), String)
      @source = T.let(validate_one_of!(source, VALID_SOURCES), String)
      @name = name
      @balance = balance
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
    def created_at=(time)
      @created_at = validate_iso8601!(time)
    end
  end
end
