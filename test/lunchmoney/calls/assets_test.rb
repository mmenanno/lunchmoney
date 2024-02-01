# typed: strict
# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class AssetsTest < ActiveSupport::TestCase
      include MockResponseHelper
      include VcrHelper

      test "assets returns an array of Asset objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("assets/assets_success") do
            api_call = LunchMoney::Calls::Assets.new.assets

            api_call.each do |asset|
              assert_kind_of(LunchMoney::Objects::Asset, asset)
            end
          end
        end
      end

      test "assets returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Assets.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Assets.new.assets

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
