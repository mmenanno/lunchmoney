# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Tag < T::Struct
    prop :id, Integer
    prop :name, String
    prop :description, T.nilable(String)
    prop :archived, T::Boolean, default: false
  end
end
