# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Category < LunchMoney::DataObject
    sig { returns(Integer) }
    attr_accessor :id

    sig { returns(String) }
    attr_accessor :name

    sig { returns(T.nilable(String)) }
    attr_accessor :description, :archived_on, :updated_at, :created_at

    sig { returns(T::Boolean) }
    attr_accessor :is_income, :exclude_from_budget, :exclude_from_totals, :archived, :is_group

    sig { returns(T.nilable(Integer)) }
    attr_accessor :group_id

    sig { returns(T::Array[LunchMoney::Category]) }
    attr_accessor :children

    sig do
      params(
        name: String,
        id: Integer,
        children: T::Array[LunchMoney::Category],
        is_income: T::Boolean,
        exclude_from_budget: T::Boolean,
        exclude_from_totals: T::Boolean,
        archived: T::Boolean,
        is_group: T::Boolean,
        archived_on: T.nilable(String),
        updated_at: T.nilable(String),
        created_at: T.nilable(String),
        group_id: T.nilable(Integer),
        description: T.nilable(String),
      ).void
    end
    def initialize(name:, id:, children:, is_income:, exclude_from_budget:, exclude_from_totals:, archived:, is_group:,
      archived_on: nil, updated_at: nil, created_at: nil, group_id: nil, description: nil)
      super()
      @name = name
      @id = id
      @children = children
      @is_income = is_income
      @exclude_from_budget = exclude_from_budget
      @exclude_from_totals = exclude_from_totals
      @archived = archived
      @is_group = is_group
      @archived_on = archived_on
      @updated_at = updated_at
      @created_at = created_at
      @group_id = group_id
      @description = description
    end
  end
end
