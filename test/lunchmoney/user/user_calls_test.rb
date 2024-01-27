# typed: strict
# frozen_string_literal: true

require "test_helper"

class UserCallsTest < ActiveSupport::TestCase
  include MockResponseHelper
  include FakeResponseDataHelper

  test "me returns a User objects on success response" do
    VCR.use_cassette("user/me_success") do
      ensure_correct_api_key
      api_call = LunchMoney::UserCalls.new.me

      assert_kind_of(LunchMoney::User, api_call)
    end
  end

  test "me returns an array of Error objects on error response" do
    response = mock_faraday_response(fake_general_error)
    LunchMoney::UserCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::UserCalls.new.me

    T.unsafe(api_call).each do |error|
      assert_kind_of(LunchMoney::Error, error)
    end
  end
end
