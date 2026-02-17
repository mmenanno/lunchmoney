# frozen_string_literal: true

module LunchMoney
  module Calls
    module Categories
      include Base

      # List all categories.
      #
      # @param format [Symbol, String, nil] :nested or :flattened (default: nil)
      # @return [Array<LunchMoney::Objects::Category>]
      def categories(format: nil)
        params = {}
        params[:format] = format.to_s if format
        data = get("/categories", params: params.presence)
        build_collection(Objects::Category, data, key: :categories)
      end

      # Get a single category by ID.
      #
      # @param id [Integer]
      # @return [LunchMoney::Objects::Category]
      # @raise [LunchMoney::NotFoundError] if category does not exist
      def category(id)
        data = get("/categories/#{id}")
        build_object(Objects::Category, data)
      end

      # Create a category (or category group when is_group: true).
      #
      # @param attrs [Hash] category attributes (name:, description:, is_income:,
      #   exclude_from_budget:, exclude_from_totals:, is_group:, category_ids:, etc.)
      # @return [LunchMoney::Objects::Category]
      def create_category(**attrs)
        data = post("/categories", body: attrs)
        build_object(Objects::Category, data)
      end

      # Update a category.
      #
      # @param id [Integer]
      # @param attrs [Hash] attributes to update
      # @return [LunchMoney::Objects::Category]
      def update_category(id, **attrs)
        data = put("/categories/#{id}", body: attrs)
        build_object(Objects::Category, data)
      end

      # Delete a category.
      #
      # @param id [Integer]
      # @return [nil]
      def delete_category(id)
        delete("/categories/#{id}")
      end
    end
  end
end
