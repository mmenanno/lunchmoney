# typed: strict
# frozen_string_literal: true

require_relative "recurring_expense"

module LunchMoney
  class RecurringExpenseCalls < ApiCall
    sig do
      params(
        start_date: T.nilable(String),
        end_date: T.nilable(String),
      ).returns(T.any(T::Array[LunchMoney::RecurringExpense], LunchMoney::Errors))
    end
    def recurring_expenses(start_date: nil, end_date: nil)
      params = {
        start_date:,
        end_date:,
      }
      params.reject! { |_key, value| value.nil? }

      response = if params.empty?
        get("recurring_expenses")
      else
        get("recurring_expenses", query_params: params)
      end

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body[:recurring_expenses].map do |recurring_expense|
        LunchMoney::RecurringExpense.new(**recurring_expense)
      end
    end
  end
end
