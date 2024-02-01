# typed: strict
# frozen_string_literal: true

require_relative "../user/user"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#user
    class Users < LunchMoney::Calls::Base
      sig { returns(T.any(LunchMoney::User, LunchMoney::Errors)) }
      def me
        response = get("me")

        api_errors = errors(response)
        return api_errors if api_errors.present?

        LunchMoney::User.new(**response.body)
      end
    end
  end
end
