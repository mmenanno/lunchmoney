# typed: strict
# frozen_string_literal: true

require_relative "asset"

module LunchMoney
  class AssetCalls < ApiCall
    sig { returns(T.any(T::Array[LunchMoney::Asset], LunchMoney::Errors)) }
    def assets
      response = get("assets")

      api_errors = errors(response)
      return api_errors if api_errors.present?

      response.body[:assets].map do |asset|
        LunchMoney::Asset.new(asset)
      end
    end

    sig do
      params(
        type_name: String,
        name: String,
        balance: String,
        subtype_name: T.nilable(String),
        display_name: T.nilable(String),
        balance_as_of: T.nilable(String),
        currency: T.nilable(String),
        institution_name: T.nilable(String),
        closed_on: T.nilable(String),
        exclude_transactions: T.nilable(T::Boolean),
      ).returns(T.any(LunchMoney::Asset, LunchMoney::Errors))
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

      api_errors = errors(response)
      return api_errors if api_errors.present?

      LunchMoney::Asset.new(response.body)
    end

    sig do
      params(
        asset_id: Integer,
        type_name: T.nilable(String),
        name: T.nilable(String),
        balance: T.nilable(String),
        subtype_name: T.nilable(String),
        display_name: T.nilable(String),
        balance_as_of: T.nilable(String),
        currency: T.nilable(String),
        institution_name: T.nilable(String),
        closed_on: T.nilable(String),
        exclude_transactions: T.nilable(T::Boolean),
      ).returns(T.any(LunchMoney::Asset, LunchMoney::Errors))
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

      api_errors = errors(response)
      return api_errors if api_errors.present?

      LunchMoney::Asset.new(response.body)
    end
  end
end
