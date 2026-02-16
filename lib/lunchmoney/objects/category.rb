# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    class Category < Base
      attr_accessor :id, :name, :description, :is_income, :exclude_from_budget, :exclude_from_totals,
                    :updated_at, :created_at, :group_id, :is_group, :children,
                    :archived, :archived_at, :order, :collapsed
    end
  end
end
