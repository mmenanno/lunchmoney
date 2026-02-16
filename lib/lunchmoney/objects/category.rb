# frozen_string_literal: true

require_relative "child_category"
module LunchMoney
  module Objects
    # https://lunchmoney.dev/#categories-object
    class Category < ChildCategory
      attr_accessor :group_category_name

      attr_accessor :is_income, :exclude_from_budget, :exclude_from_totals, :is_group

      attr_accessor :group_id, :order

      attr_accessor :children

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
end
