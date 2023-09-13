# typed: strict
# frozen_string_literal: true

require_relative "user"

module LunchMoney
  class UserCalls < ApiCall
    sig { returns(T.any(LunchMoney::User, LunchMoney::Errors)) }
    def user
      response = get("me")

      api_errors = errors(response)
      return api_errors if api_errors.present?

      LunchMoney::User.new(response.body)
    end
  end
end
