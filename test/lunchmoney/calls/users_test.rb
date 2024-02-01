# typed: strict
# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class UsersTest < ActiveSupport::TestCase
      include MockResponseHelper
      include VcrHelper

      test "me returns a User objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("user/me_success") do
            api_call = LunchMoney::Calls::Users.new.me

            assert_kind_of(LunchMoney::User, api_call)
          end
        end
      end

      test "me returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Users.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Users.new.me

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
