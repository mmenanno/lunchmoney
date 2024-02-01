# typed: strict
# frozen_string_literal: true

require_relative "../tags/tag/tag"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#tags
    class Tags < LunchMoney::Calls::Base
      sig { returns(T.any(T::Array[LunchMoney::Tag], LunchMoney::Errors)) }
      def tags
        response = get("tags")

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body.map { |tag| LunchMoney::Tag.new(**tag) }
      end
    end
  end
end
