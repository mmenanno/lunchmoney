# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#tags-object without some fields. This is used for the returns from transactions calls
  class TransactionTag < LunchMoney::DataObject
    sig { returns(Integer) }
    attr_accessor :id

    sig { returns(String) }
    attr_accessor :name

    sig { params(id: Integer, name: String).void }
    def initialize(id:, name:)
      super()
      @id = id
      @name = name
    end
  end
end
