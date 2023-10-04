# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Error
    sig { returns(String) }
    attr_reader :message

    sig { params(message: String).void }
    def initialize(message:)
      @message = message
    end
  end
end

LunchMoney::Errors = T.type_alias { T::Array[LunchMoney::Error] }
