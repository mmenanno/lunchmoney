# frozen_string_literal: true

module LunchMoney
  module Calls
    module Me
      include Base

      # Returns the authenticated user's account information.
      #
      # @return [LunchMoney::Objects::User]
      # @raise [LunchMoney::AuthenticationError] if API key is invalid
      # @see https://alpha.lunchmoney.dev/v2/docs#/User/get_me
      def me
        data = get("/me")
        build_object(Objects::User, data)
      end
    end
  end
end
