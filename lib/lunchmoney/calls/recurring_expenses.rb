# typed: strict
# frozen_string_literal: true

require_relative "../objects/recurring_expense"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#recurring-expenses
    class RecurringExpenses < LunchMoney::Calls::Base
      sig do
        params(
          start_date: T.nilable(String),
          end_date: T.nilable(String),
        ).returns(T.any(T::Array[LunchMoney::Objects::RecurringExpense], LunchMoney::Errors))
      end
      def recurring_expenses(start_date: nil, end_date: nil)
        params = clean_params({ start_date:, end_date: })
        response = get("recurring_expenses", query_params: params)

        handle_api_response(response) do |body|
          body[:recurring_expenses].map do |recurring_expense|
            LunchMoney::Objects::RecurringExpense.new(**recurring_expense)
          end
        end
      end
    end
  end
end
