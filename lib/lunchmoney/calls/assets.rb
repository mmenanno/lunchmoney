# frozen_string_literal: true

require_relative "../objects/asset"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#assets
    class Assets < LunchMoney::Calls::Base
      def assets
        response = get("assets")

        handle_api_response(response) do |body|
          body[:assets].map do |asset|
            LunchMoney::Objects::Asset.new(**asset)
          end
        end
      end

      def create_asset(type_name:, name:, balance:, subtype_name: nil, display_name: nil, balance_as_of: nil,
        currency: nil, institution_name: nil, closed_on: nil, exclude_transactions: nil)
        params = {
          type_name:,
          name:,
          balance:,
          subtype_name:,
          display_name:,
          balance_as_of:,
          currency:,
          institution_name:,
          closed_on:,
          exclude_transactions:,
        }

        response = post("assets", params)

        handle_api_response(response) do |body|
          LunchMoney::Objects::Asset.new(**body)
        end
      end

      def update_asset(asset_id, type_name: nil, name: nil, balance: nil, subtype_name: nil, display_name: nil,
        balance_as_of: nil, currency: nil, institution_name: nil, closed_on: nil, exclude_transactions: nil)
        params = {
          type_name:,
          name:,
          balance:,
          subtype_name:,
          display_name:,
          balance_as_of:,
          currency:,
          institution_name:,
          closed_on:,
          exclude_transactions:,
        }

        response = put("assets/#{asset_id}", params)

        handle_api_response(response) do |body|
          LunchMoney::Objects::Asset.new(**body)
        end
      end
    end
  end
end
