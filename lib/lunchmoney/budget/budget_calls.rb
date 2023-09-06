# typed: strict
# frozen_string_literal: true

require_relative "budget"

module LunchMoney
  class BudgetCalls < BaseApiCall
    sig do
      params(
        start_date: String,
        end_date: String,
        currency: T.nilable(String),
      ).returns(T::Array[LunchMoney::RecurringExpense])
    end
    def budget_summary(start_date:, end_date:, currency: nil)
      params = {
        start_date:,
        end_date:,
        currency:,
      }
      params.reject! { |_key, value| value.nil? }

      response = get("budgets", query_params: params)

      errors(response)

      response.body.map do |budget|
        # budget[:data] TODO: Add mapping to data object

        LunchMoney::RecurringExpense.new(budget)
      end
    end

    sig do
      params(
        start_date: String,
        category_id: Integer,
        amount: Integer,
        currency: T.nilable(String),
      ).returns(T::Hash[String, { category_id: Integer, amount: Integer, currency: String, start_date: String }])
    end
    def upsert_budget(start_date:, category_id:, amount:, currency: nil)
      params = {
        start_date:,
        category_id:,
        amount:,
        currency:,
      }
      params.reject! { |_key, value| value.nil? }

      response = put("budgets", params)

      errors(response)

      response.body
    end

    sig { params(start_date: String, category_id: Integer).returns(T::Boolean) }
    def remove_budget(start_date:, category_id:)
      # params = {
      #   start_date:,
      #   category_id:,
      # }

      # TODO: Add params to delete call
      response = delete("budgets")

      errors(response)

      response.body
    end
  end
end
