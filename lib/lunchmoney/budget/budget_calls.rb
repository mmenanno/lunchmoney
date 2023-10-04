# typed: strict
# frozen_string_literal: true

require_relative "budget"

module LunchMoney
  class BudgetCalls < ApiCall
    sig do
      params(
        start_date: String,
        end_date: String,
        currency: T.nilable(String),
      ).returns(T.any(T::Array[LunchMoney::Budget], LunchMoney::Errors))
    end
    def budget_summary(start_date:, end_date:, currency: nil)
      params = {
        start_date:,
        end_date:,
        currency:,
      }
      params.reject! { |_key, value| value.nil? }

      response = get("budgets", query_params: params)

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body.map do |budget|
        # budget[:data] TODO: Add mapping to data object

        LunchMoney::Budget.new(**budget)
      end
    end

    sig do
      params(
        start_date: String,
        category_id: Integer,
        amount: Integer,
        currency: T.nilable(String),
      ).returns(T.any(
        T::Hash[String, { category_id: Integer, amount: Integer, currency: String, start_date: String }],
        LunchMoney::Errors,
      ))
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

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body
    end

    sig { params(start_date: String, category_id: Integer).returns(T.any(T::Boolean, LunchMoney::Errors)) }
    def remove_budget(start_date:, category_id:)
      # params = {
      #   start_date:,
      #   category_id:,
      # }

      # TODO: Add params to delete call
      response = delete("budgets")

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body
    end
  end
end
