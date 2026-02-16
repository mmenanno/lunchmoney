# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    class CreateCategory < Base
      attr_accessor :name, :description, :is_income, :exclude_from_budget, :exclude_from_totals,
                    :is_group, :group_id, :archived, :children, :order,
                    :collapsed

      def validate!
        raise ArgumentError, "name is required" if name.nil?
        raise ArgumentError, "name must be at most 100 characters" if name && name.to_s.length > 100
        raise ArgumentError, "name must be at least 1 characters" if name && name.to_s.length < 1
        raise ArgumentError, "description must be at most 200 characters" if description && description.to_s.length > 200
      end
    end
  end
end
