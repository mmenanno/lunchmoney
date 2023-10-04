# typed: strict
# frozen_string_literal: true

require_relative "tag"

module LunchMoney
  class TagCalls < ApiCall
    sig { returns(T.any(T::Array[LunchMoney::Tag], LunchMoney::Errors)) }
    def all_tags
      response = get("tags")

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body.map { |tag| LunchMoney::Tag.new(**tag) }
    end
  end
end
