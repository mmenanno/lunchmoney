# typed: strict
# frozen_string_literal: true

module LunchMoney
  class ApiError < T::Struct
    const :message, String
  end
end

LunchMoney::Errors = T.type_alias { T::Array[LunchMoney::ApiError] }
