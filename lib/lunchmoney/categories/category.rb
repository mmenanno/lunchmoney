# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Category < T::Struct
    prop :id, Integer
    prop :name, String
    prop :description, T.nilable(String)
    prop :is_income, T::Boolean, default: false
    prop :exclude_from_budget, T::Boolean, default: false
    prop :exclude_from_totals, T::Boolean, default: false
    prop :archived, T::Boolean, default: false
    prop :archived_on, T.nilable(String)
    prop :updated_at, T.nilable(String)
    prop :created_at, T.nilable(String)
    prop :is_group, T::Boolean, default: false
    prop :group_id, T.nilable(Integer)
    prop :children, T::Array[LunchMoney::Category], default: []
  end
end
