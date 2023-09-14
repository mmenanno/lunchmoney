# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Error < T::Struct
    const :message, String
  end
end

LunchMoney::Errors = T.type_alias { T::Array[LunchMoney::Error] }
