# typed: strict
# frozen_string_literal: true

require_relative "data"
require_relative "config"

module LunchMoney
  class Budget < LunchMoney::DataObject
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
    attr_accessor :is_income, :exclude_from_budget, :exclude_from_totals

    sig { returns(T::Hash[Symbol, LunchMoney::Data]) }
    attr_accessor :data

    # TODO: this needs to be better typed
    sig { returns(T.nilable(LunchMoney::Config)) }
    attr_accessor :config

    sig do
      params(
        is_income: T::Boolean,
        exclude_from_budget: T::Boolean,
        exclude_from_totals: T::Boolean,
        data: T::Hash[Symbol, LunchMoney::Data],
        category_name: String,
        order: Integer,
        category_id: T.nilable(Integer),
        category_group_name: T.nilable(String),
        group_id: T.nilable(Integer),
        is_group: T.nilable(T::Boolean),
        config: T.nilable(T::Hash[Symbol, LunchMoney::Config]),
      ).void
    end
    def initialize(is_income:, exclude_from_budget:, exclude_from_totals:, data:,
      category_name:, order:, category_id: nil, category_group_name: nil, group_id: nil, is_group: nil, config: nil)
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
    end
  end
end
