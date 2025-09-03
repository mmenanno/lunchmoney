# typed: strict
# frozen_string_literal: true

require_relative "../objects/tag"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#tags
    class Tags < LunchMoney::Calls::Base
      sig { returns(T.any(T::Array[LunchMoney::Objects::Tag], LunchMoney::Errors)) }
      def tags
        response = get("tags")

        handle_api_response(response) do |body|
          body.map { |tag| LunchMoney::Objects::Tag.new(**tag) }
        end
      end
    end
  end
end
