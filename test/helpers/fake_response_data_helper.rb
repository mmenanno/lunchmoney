# typed: strict
# frozen_string_literal: true

module FakeResponseDataHelper
  sig { returns(T::Hash[Symbol, String]) }
  def fake_general_error
    { error: "This is an error" }
  end

  sig { returns(T::Hash[Symbol, T::Array[T::Hash[String, T.any(Integer, String, T::Boolean)]]]) }
  def fake_assets_response
    {
      assets: [{
        "id": 72,
        "type_name": "cash",
        "subtype_name": "retirement",
        "name": "Test Asset 1",
        "balance": "1201.0100",
        "balance_as_of": "2020-01-26T12:27:22.000Z",
        "currency": "cad",
        "institution_name": "Bank of Me",
        "created_at": "2020-01-26T12:27:22.726Z",
        "exclude_transactions": false,
      }],
    }
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
end
