# typed: strict
# frozen_string_literal: true

require_relative "tag"

module LunchMoney
  class TagCalls < BaseApiCall
    sig { returns(T::Array[LunchMoney::Tag]) }
    def all_tags
      response = get("tags")

      errors(response)

      response.body.map { |tag| LunchMoney::Tag.new(tag) }
    end
  end
end
