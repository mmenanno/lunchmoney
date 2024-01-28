# typed: strict
# frozen_string_literal: true

module FakeResponseDataHelper
  private

  sig { returns(T::Hash[Symbol, String]) }
  def fake_general_error
    { error: "This is an error" }
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
