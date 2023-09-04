# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "struct"

module LunchMoney
  class Category < T::Struct
    prop :id, Integer
    prop :name, String
    prop :description, T.nilable(String)
    prop :is_income, T::Boolean, default: false
    prop :exclude_from_budget, T::Boolean, default: false
    prop :exclude_from_totals, T::Boolean, default: false
    prop :updated_at, String
    prop :created_at, String
    prop :is_group, T::Boolean
    prop :group_id, T.nilable(Integer)
  end
end
