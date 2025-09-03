# typed: strict
# frozen_string_literal: true

require_relative "../objects/user"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#user
    class Users < LunchMoney::Calls::Base
      sig { returns(T.any(LunchMoney::Objects::User, LunchMoney::Errors)) }
      def me
        response = get("me")

        handle_api_response(response) do |body|
          LunchMoney::Objects::User.new(**body)
        end
      end
    end
  end
end
