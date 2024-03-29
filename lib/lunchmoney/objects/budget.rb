# typed: strict
# frozen_string_literal: true

require_relative "data"
require_relative "config"

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#budget-object
    class Budget < LunchMoney::Objects::Object
      # API object reference documentation: https://lunchmoney.dev/#budget-object

      sig { returns(String) }
      attr_accessor :category_name

      sig { returns(Integer) }
      attr_accessor :order

      sig { returns(T.nilable(String)) }
      attr_accessor :category_group_name

      sig { returns(T.nilable(Integer)) }
      attr_accessor :category_id, :group_id

      sig { returns(T.nilable(T::Boolean)) }
      attr_accessor :is_group

      sig { returns(T::Boolean) }
      attr_accessor :is_income, :exclude_from_budget, :exclude_from_totals, :archived

      sig { returns(T::Hash[Symbol, LunchMoney::Objects::Data]) }
      attr_accessor :data

      sig { returns(T.nilable(T::Hash[Symbol, LunchMoney::Objects::Config])) }
      attr_accessor :config

      sig { returns(T.nilable({ list: T::Array[LunchMoney::Objects::RecurringExpense] })) }
      attr_accessor :recurring

      sig do
        params(
          is_income: T::Boolean,
          exclude_from_budget: T::Boolean,
          exclude_from_totals: T::Boolean,
          data: T::Hash[Symbol, LunchMoney::Objects::Data],
          category_name: String,
          order: Integer,
          archived: T::Boolean,
          category_id: T.nilable(Integer),
          category_group_name: T.nilable(String),
          group_id: T.nilable(Integer),
          is_group: T.nilable(T::Boolean),
          config: T.nilable(T::Hash[Symbol, LunchMoney::Objects::Config]),
          recurring: T.nilable({ list: T::Array[LunchMoney::Objects::RecurringExpense] }),
        ).void
      end
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
