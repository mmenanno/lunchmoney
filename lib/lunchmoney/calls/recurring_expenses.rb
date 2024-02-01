# typed: strict
# frozen_string_literal: true

require_relative "../recurring_expenses/recurring_expense/recurring_expense"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#recurring-expenses
    class RecurringExpenses < LunchMoney::Calls::Base
      sig do
        params(
          start_date: T.nilable(String),
          end_date: T.nilable(String),
        ).returns(T.any(T::Array[LunchMoney::RecurringExpense], LunchMoney::Errors))
      end
      def recurring_expenses(start_date: nil, end_date: nil)
        params = clean_params({ start_date:, end_date: })
        response = get("recurring_expenses", query_params: params)

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body[:recurring_expenses].map do |recurring_expense|
          LunchMoney::RecurringExpense.new(**recurring_expense)
        end
      end
    end
  end
end
