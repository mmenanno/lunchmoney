# typed: strict
# frozen_string_literal: true

module FakeResponseDataHelper
  private

  sig { returns(T::Hash[Symbol, String]) }
  def fake_general_error
    { error: "This is an error" }
  end

  sig { returns(T::Hash[Symbol, T::Array[T::Hash[String, T.any(Integer, String, T::Boolean)]]]) }
  def fake_assets_response
    { assets: [create_asset.serialize(symbolize_keys: true)] }
  end

  sig do
    params(
      type_name: String,
      subtype_name: String,
      balance_as_of: String,
      created_at: String,
    ).returns(LunchMoney::Asset)
  end
  def create_asset(type_name: "cash", subtype_name: "retirement", balance_as_of: "2023-01-01T01:01:01.000Z",
    created_at: "2023-01-01T01:01:01.000Z")
    LunchMoney::Asset.new(
      "id": 1,
      "type_name": type_name,
      "subtype_name": subtype_name,
      "name": "Test Asset 1",
      "balance": "1201.0100",
      "balance_as_of": balance_as_of,
      "currency": "cad",
      "institution_name": "Bank of Me",
      "exclude_transactions": false,
      "created_at": created_at,
    )
  end

  sig { returns(T::Array[T::Hash[String, T.nilable(T.any(String, Integer, Float, T::Boolean))]]) }
  def fake_budget_summary_response
    [
      {
        "category_name": "Food",
        "category_id": 34476,
        "category_group_name": nil,
        "group_id": nil,
        "is_group": true,
        "is_income": false,
        "exclude_from_budget": false,
        "exclude_from_totals": false,
        "data": {
          "2020-09-01": {
            "num_transactions": 23,
            "spending_to_base": 373.51,
            "budget_to_base": 376.08,
            "budget_amount": 376.08,
            "budget_currency": "usd",
            "is_automated": true,
          },
          "2020-08-01": {
            "num_transactions": 23,
            "spending_to_base": 123.92,
            "budget_to_base": 300,
            "budget_amount": 300,
            "budget_currency": "usd",
          },
          "2020-07-01": {
            "num_transactions": 23,
            "spending_to_base": 228.66,
            "budget_to_base": 300,
            "budget_amount": 300,
            "budget_currency": "usd",
          },
        },
        "config": {
          "config_id": 9,
          "cadence": "monthly",
          "amount": 300,
          "currency": "usd",
          "to_base": 300,
          "auto_suggest": "fixed-rollover",
        },
        "order": 0,
      },
      {
        "category_name": "Alcohol & Bars",
        "category_id": 26,
        "category_group_name": "Food",
        "group_id": 34476,
        "is_group": nil,
        "is_income": false,
        "exclude_from_budget": false,
        "exclude_from_totals": false,
        "data": {
          "2020-09-01": {
            "spending_to_base": 270.86,
            "num_transactions": 14,
          },
          "2020-08-01": {
            "spending_to_base": 79.53,
            "num_transactions": 8,
          },
          "2020-07-01": {
            "spending_to_base": 149.61,
            "num_transactions": 8,
          },
        },
        "config": nil,
        "order": 1,
      },
    ]
  end

  sig { returns(T::Hash[String, T.untyped]) }
  def fake_all_categories_response
    {
      "categories": [
        {
          "id": 83,
          "name": "Test 1",
          "description": "Test description",
          "is_income": false,
          "exclude_from_budget": true,
          "exclude_from_totals": false,
          "updated_at": "2020-01-28T09:49:03.225Z",
          "created_at": "2020-01-28T09:49:03.225Z",
          "is_group": false,
          "group_id": nil,
          "order": 0,
        },
        {
          "id": 84,
          "name": "Test 2",
          "description": nil,
          "is_income": true,
          "exclude_from_budget": false,
          "exclude_from_totals": true,
          "updated_at": "2020-01-28T09:49:03.238Z",
          "created_at": "2020-01-28T09:49:03.238Z",
          "is_group": true,
          "group_id": 83,
          "order": 1,
          "children": [
            {
              "id": 315162,
              "name": "Alcohol, Bars",
              "description": nil,
              "is_income": false,
              "exclude_from_budget": false,
              "exclude_from_totals": false,
              "created_at": "2022-03-06T20:11:36.066Z",
              "is_group": false,
            },
            {
              "id": 315169,
              "name": "Groceries",
              "description": nil,
              "is_income": false,
              "exclude_from_budget": false,
              "exclude_from_totals": false,
              "created_at": "2022-03-06T20:11:36.120Z",
              "is_group": false,
            },
            {
              "id": 315172,
              "name": "Restaurants",
              "description": nil,
              "is_income": false,
              "exclude_from_budget": false,
              "exclude_from_totals": false,
              "created_at": "2022-03-06T20:11:36.146Z",
              "is_group": false,
            },
          ],
        },
      ],
    }
  end
end
