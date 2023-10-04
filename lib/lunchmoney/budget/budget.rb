# typed: strict
# frozen_string_literal: true

require_relative "data"

module LunchMoney
  class Budget < LunchMoney::DataObject
    sig { returns(String) }
    attr_accessor :category_name

    sig { returns(Integer) }
    attr_accessor :category_id

    sig { returns(T.nilable(String)) }
    attr_accessor :category_group_name

    sig { returns(T.nilable(Integer)) }
    attr_accessor :group_id

    sig { returns(T.nilable(T::Boolean)) }
    attr_accessor :is_group

    sig { returns(T::Boolean) }
    attr_accessor :is_income, :exclude_from_budget, :exclude_from_totals

    sig { returns(T::Hash[Symbol, LunchMoney::Data]) }
    attr_accessor :data

    # TODO: this needs to be better typed
    sig { returns(T::Hash[T.untyped, T.untyped]) }
    attr_accessor :config

    sig do
      params(
        config: T::Hash[T.untyped, T.untyped],
        category_id: Integer,
        is_income: T::Boolean,
        exclude_from_budget: T::Boolean,
        exclude_from_totals: T::Boolean,
        data: T::Hash[Symbol, LunchMoney::Data],
        category_name: String,
        category_group_name: T.nilable(String),
        group_id: T.nilable(Integer),
        is_group: T.nilable(T::Boolean),
      ).void
    end
    def initialize(config:, category_id:, is_income:, exclude_from_budget:, exclude_from_totals:, data:,
      category_name:, category_group_name: nil, group_id: nil, is_group: nil)
      super()
      @config = config
      @category_id = category_id
      @is_income = is_income
      @exclude_from_budget = exclude_from_budget
      @exclude_from_totals = exclude_from_totals
      @data = data
      @category_name = category_name
      @category_group_name = category_group_name
      @group_id = group_id
      @is_group = is_group
    end
  end
end
