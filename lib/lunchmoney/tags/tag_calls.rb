# typed: strict
# frozen_string_literal: true

require_relative "tag"
require_relative "transaction_tag"

module LunchMoney
  # https://lunchmoney.dev/#tags
  class TagCalls < ApiCall
    sig { returns(T.any(T::Array[LunchMoney::Tag], LunchMoney::Errors)) }
    def tags
      response = get("tags")

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body.map { |tag| LunchMoney::Tag.new(**tag) }
    end
  end
end
