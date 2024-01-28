# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#categories-object
  class Category < ChildCategory
    sig { returns(T.nilable(String)) }
    attr_accessor :group_category_name

    sig { returns(T::Boolean) }
    attr_accessor :is_income, :exclude_from_budget, :exclude_from_totals, :is_group

    sig { returns(T.nilable(Integer)) }
    attr_accessor :group_id, :order

    sig { returns(T.nilable(T::Array[T.any(LunchMoney::Category, LunchMoney::ChildCategory)])) }
    attr_accessor :children

    sig do
      params(
        id: Integer,
        name: String,
        is_income: T::Boolean,
        exclude_from_budget: T::Boolean,
        exclude_from_totals: T::Boolean,
        is_group: T::Boolean,
        archived: T.nilable(T::Boolean),
        archived_on: T.nilable(String),
        updated_at: T.nilable(String),
        created_at: T.nilable(String),
        group_id: T.nilable(Integer),
        order: T.nilable(Integer),
        description: T.nilable(String),
        children: T.nilable(T::Array[T.any(LunchMoney::Category, LunchMoney::ChildCategory)]),
        group_category_name: T.nilable(String),
      ).void
    end
    def initialize(id:, name:, is_income:, exclude_from_budget:, exclude_from_totals:, is_group:, archived: nil,
      archived_on: nil, updated_at: nil, created_at: nil, group_id: nil, order: nil, description: nil, children: nil,
      group_category_name: nil)
      super(id:, name:, archived:, archived_on:, updated_at:, created_at:, description:)
      @is_income = is_income
      @exclude_from_budget = exclude_from_budget
      @exclude_from_totals = exclude_from_totals
      @is_group = is_group
      @group_id = group_id
      @order = order
      @children = children
      @group_category_name = group_category_name
    end
  end
end
