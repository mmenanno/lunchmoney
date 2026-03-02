# frozen_string_literal: true

module LunchMoney
  module Calls
    module RecurringItems
      include Base

      # List all recurring items.
      #
      # @param start_date [String] ISO 8601 date (required)
      # @param end_date [String] ISO 8601 date (required)
      # @return [Array<LunchMoney::Objects::RecurringItem>]
      def recurring_items(start_date:, end_date:)
        params = { start_date:, end_date: }
        data = get("/recurring_items", params: params)
        build_collection(Objects::RecurringItem, data, key: :recurring_items)
      end

      # Get a single recurring item by ID.
      #
      # @param id [Integer]
      # @param start_date [String] ISO 8601 date (required for occurrence calculation)
      # @param end_date [String] ISO 8601 date (required for occurrence calculation)
      # @return [LunchMoney::Objects::RecurringItem]
      # @raise [LunchMoney::NotFoundError]
      def recurring_item(id, start_date:, end_date:)
        params = { start_date:, end_date: }
        data = get("/recurring_items/#{id}", params: params)
        build_object(Objects::RecurringItem, data)
      end
    end
  end
end
