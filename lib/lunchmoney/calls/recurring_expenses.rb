# frozen_string_literal: true

require_relative "../objects/recurring_expense"
require_relative "../deprecate"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#recurring-expenses
    class RecurringExpenses < LunchMoney::Calls::Base
      include LunchMoney::Deprecate

      def recurring_expenses(start_date: nil, end_date: nil)
        deprecate_endpoint("recurring_items", level: :warning)
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
