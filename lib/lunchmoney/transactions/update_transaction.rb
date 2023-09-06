# typed: strict
# frozen_string_literal: true

module LunchMoney
  class UpdateTransaction < T::Struct
    prop :date, T.nilable(String)
    prop :category_id, T.nilable(Integer)
    prop :payee, T.nilable(String)
    prop :amount, T.nilable(String)
    prop :currency, T.nilable(String)
    prop :asset_id, T.nilable(Integer)
    prop :recurring_id, T.nilable(Integer)
    prop :notes, T.nilable(String)
    prop :status, T.nilable(String)
    prop :external_id, T.nilable(String)
    prop :tags, T.nilable(T::Array[T.any(String, Integer)])
  end
end
