# frozen_string_literal: true

require_relative "data"
require_relative "config"

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#budget-object
    class Budget < LunchMoney::Objects::Object
      # API object reference documentation: https://lunchmoney.dev/#budget-object

      attr_accessor :category_name

      attr_accessor :order

      attr_accessor :category_group_name

      attr_accessor :category_id, :group_id

      attr_accessor :is_group

      attr_accessor :is_income, :exclude_from_budget, :exclude_from_totals, :archived

      attr_accessor :data

      attr_accessor :config

      attr_accessor :recurring

      def initialize(is_income:, exclude_from_budget:, exclude_from_totals:, data:, category_name:, order:, archived:,
        category_id: nil, category_group_name: nil, group_id: nil, is_group: nil, config: nil, recurring: nil)
        super()
        @category_id = category_id
        @is_income = is_income
        @exclude_from_budget = exclude_from_budget
        @exclude_from_totals = exclude_from_totals
        @data = data
        @category_name = category_name
        @order = order
        @category_group_name = category_group_name
        @group_id = group_id
        @is_group = is_group
        @config = config
        @archived = archived
        @recurring = recurring
      end
    end
  end
end
