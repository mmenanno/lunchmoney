# typed: strict
# frozen_string_literal: true

require "test_helper"

class AssetCallsTest < ActiveSupport::TestCase
  include MockResponseHelper

  test "assets returns an array of Asset objects on success response" do
    response = mock_faraday_response({
      assets: [{
        "id": 72,
        "type_name": "cash",
        "subtype_name": "physical cash",
        "name": "Test Asset 1",
        "balance": "1201.0100",
        "balance_as_of": "2020-01-26T12:27:22.000Z",
        "currency": "cad",
        "institution_name": "Bank of Me",
        "created_at": "2020-01-26T12:27:22.726Z",
        "exclude_transactions": false,
      }],
    })

    LunchMoney::AssetCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::AssetCalls.new.assets

    assert_kind_of(LunchMoney::Asset, api_call.first)
  end

  test "assets returns an array of Error objects on error response" do
    response = mock_faraday_response({ "error": "This is an error" })

    LunchMoney::AssetCalls.any_instance.stubs(:get).returns(response)

    api_call = LunchMoney::AssetCalls.new.assets

    assert_kind_of(LunchMoney::Error, api_call.first)
  end
end
