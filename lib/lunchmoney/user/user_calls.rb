# typed: strict
# frozen_string_literal: true

require_relative "user"

module LunchMoney
  class UserCalls < ApiCall
    sig { returns(LunchMoney::User) }
    def user
      response = get("me")

      errors(response)

      LunchMoney::User.new(response.body)
    end
  end
end
