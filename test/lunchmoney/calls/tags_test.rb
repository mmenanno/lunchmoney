# typed: strict
# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class TagsTest < ActiveSupport::TestCase
      include MockResponseHelper
      include VcrHelper

      test "tags returns an array of Tag objects on success response" do
        with_real_ci_connections do
          VCR.use_cassette("tags/tags_success") do
            api_call = LunchMoney::Calls::Tags.new.tags

            api_call.each do |tag|
              assert_kind_of(LunchMoney::Objects::Tag, tag)
            end
          end
        end
      end

      test "tags returns an array of Error objects on error response" do
        response = mock_faraday_lunchmoney_error_response
        LunchMoney::Calls::Tags.any_instance.stubs(:get).returns(response)

        api_call = LunchMoney::Calls::Tags.new.tags

        assert_kind_of(LunchMoney::Errors, api_call)
      end
    end
  end
end
