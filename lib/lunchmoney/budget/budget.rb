# typed: strict
# frozen_string_literal: true

require_relative "data"

module LunchMoney
  class Budget < T::Struct
    prop :category_name, String
    prop :category_id, Integer
    prop :category_group_name, T.nilable(String)
    prop :group_id, T.nilable(Integer)
    prop :is_group, T.nilable(T::Boolean)
    prop :is_income, T::Boolean
    prop :exclude_from_budget, T::Boolean
    prop :exclude_from_totals, T::Boolean
    prop :data, T::Hash[Symbol, LunchMoney::Data]
    prop :config, T::Hash[T.untyped, T.untyped] # TODO: this needs to be better typed
  end
end
