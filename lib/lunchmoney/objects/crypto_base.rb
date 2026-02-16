# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#crypto-object
    class CryptoBase < LunchMoney::Objects::Object
      include LunchMoney::Validators

      attr_accessor :id, :zabo_account_id

      attr_reader :source, :created_at

      attr_accessor :name, :balance

      attr_accessor :display_name, :institution_name

      # Valid crypto source types
      VALID_SOURCES = [
        "synced",
        "manual",
      ].freeze

      def initialize(created_at:, source:, name:, balance:, institution_name: nil, id: nil, zabo_account_id: nil,
        display_name: nil)
        super()
        @created_at = validate_iso8601!(created_at)
        @source = validate_one_of!(source, VALID_SOURCES)
        @name = name
        @balance = balance
        @institution_name = institution_name
        @id = id
        @zabo_account_id = zabo_account_id
        @display_name = display_name
      end

      def source=(name)
        @source = validate_one_of!(name, VALID_SOURCES)
      end

      def created_at=(time)
        @created_at = validate_iso8601!(time)
      end
    end
  end
end
