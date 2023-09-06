# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Split < T::Struct
    prop :payee, T.nilable(String)
    prop :date, T.nilable(String)
    prop :category_id, T.nilable(Integer)
    prop :notes, T.nilable(String)
    prop :amount, T.any(Integer, String)
  end
end
