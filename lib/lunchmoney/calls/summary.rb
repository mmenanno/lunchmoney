# frozen_string_literal: true

module LunchMoney
  module Calls
    module Summary
      include Base

      # Get a budget/spending summary for a date range.
      #
      # Returns an AlignedResponse or NonAlignedResponse depending on whether
      # the date range aligns with the user's budget period configuration.
      #
      # @param start_date [String] ISO 8601 date
      # @param end_date [String] ISO 8601 date
      # @return [LunchMoney::Objects::Summary::AlignedSummaryResponse,
      #          LunchMoney::Objects::Summary::NonAlignedSummaryResponse]
      def summary(start_date:, end_date:)
        params = { start_date:, end_date: }
        data = get("/summary", params: params)

        if data[:aligned]
          build_object(Objects::Summary::AlignedSummaryResponse, data)
        else
          build_object(Objects::Summary::NonAlignedSummaryResponse, data)
        end
      end
    end
  end
end
