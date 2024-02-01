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

      test "create_asset returns an Asset object on success response" do
        VCR.use_cassette("assets/create_asset_success") do
          api_call = LunchMoney::Calls::Assets.new.create_asset(
            type_name: "cash",
            name: "Create Asset Test",
            balance: "10.00",
          )

          assert_kind_of(LunchMoney::Objects::Asset, api_call)
        end
      end

      test "create_asset returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Assets.any_instance.stubs(:post).returns(response)

        api_call = LunchMoney::Calls::Assets.new.create_asset(
          type_name: "cash",
          name: "Create Asset Test",
          balance: "10.00",
        )

        assert_kind_of(LunchMoney::Errors, api_call)
      end

      test "update_asset returns an Asset object on success response" do
        VCR.use_cassette("assets/update_asset_success") do
          api_call = LunchMoney::Calls::Assets.new.update_asset(93746, balance: "99.99")

          assert_kind_of(LunchMoney::Objects::Asset, api_call)
        end
      end

      test "update_asset returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Assets.any_instance.stubs(:put).returns(response)

        api_call = LunchMoney::Calls::Assets.new.update_asset(93746, balance: "99.99")

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
