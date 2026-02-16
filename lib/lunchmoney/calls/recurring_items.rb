# frozen_string_literal: true

require_relative "../objects/recurring_item"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#recurring-items
    class RecurringItems < LunchMoney::Calls::Base
      def recurring_items(start_date: nil, end_date: nil)
        params = clean_params({ start_date:, end_date: })
        response = get("recurring_items", query_params: params)

        handle_api_response(response) do |body|
          body.map do |recurring_item|
            LunchMoney::Objects::RecurringItem.new(**recurring_item)
          end
        end
      end
    end
  end
end
