# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "struct"
require_relative "data"

module LunchMoney
  extend T::Sig
  class Budget < T::Struct
    prop :category_name, String
    prop :category_id, Integer
    prop :category_group_name, T.nilable(String)
    prop :group_id, T. nilable(Integer)
    prop :is_group, T.nilable(T::Boolean)
    prop :is_income, T::Boolean
    prop :exclude_from_budget, T::Boolean
    prop :exclude_from_totals, T::Boolean
    prop :data, T::Hash[Symbol, LunchMoney::Data]
    prop :order, Integer
  end
end
