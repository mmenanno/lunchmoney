# typed: strict
# frozen_string_literal: true

module LunchMoney
  # This class is used to represent errors returned directly from the LunchMoney API
  class Error
    sig { returns(String) }
    attr_reader :message

    sig { params(message: String).void }
    def initialize(message:)
      @message = message
    end
  end
end

# A type alias for an array of LunchMoney::Error
LunchMoney::Errors = T.type_alias { T::Array[LunchMoney::Error] }
