# frozen_string_literal: true

require_relative "../objects/category"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#categories
    class Categories < LunchMoney::Calls::Base
      # Valid query parameter formats for categories
      VALID_FORMATS = [
        "flattened",
        "nested",
      ].freeze

      def categories(format: nil)
        response = get("categories", query_params: categories_params(format:))

        handle_api_response(response) do |body|
          body[:categories].map do |category|
            category[:children]&.map! { |child_category| LunchMoney::Objects::Category.new(**child_category) }

            LunchMoney::Objects::Category.new(**category)
          end
        end
      end

      def category(category_id)
        response = get("categories/#{category_id}")

        handle_api_response(response) do |body|
          body[:children]&.map! { |child_category| LunchMoney::Objects::ChildCategory.new(**child_category) }

          LunchMoney::Objects::Category.new(**body)
        end
      end

      def create_category(name:, description: nil, is_income: false, exclude_from_budget: false,
        exclude_from_totals: false, archived: false, group_id: nil)
        params = clean_params({
          name:,
          description:,
          is_income:,
          exclude_from_budget:,
          exclude_from_totals:,
          archived:,
          group_id:,
        })
        response = post("categories", params)

        handle_api_response(response) do |body|
          body
        end
      end

      def create_category_group(name:, description: nil, is_income: false, exclude_from_budget: false,
        exclude_from_totals: false, category_ids: [], new_categories: [])
        params = {
          name:,
          description:,
          is_income:,
          exclude_from_budget:,
          exclude_from_totals:,
          category_ids:,
          new_categories:,
        }

        response = post("categories/group", params)

        handle_api_response(response) do |body|
          body
        end
      end

      def update_category(category_id, name: nil, description: nil, is_income: nil, exclude_from_budget: nil,
        exclude_from_totals: nil, archived: nil, group_id: nil)
        params = clean_params({
          name:,
          description:,
          is_income:,
          exclude_from_budget:,
          exclude_from_totals:,
          archived:,
          group_id:,
        })
        response = put("categories/#{category_id}", params)

        handle_api_response(response) do |body|
          body
        end
      end

      def add_to_category_group(group_id, category_ids: [], new_categories: [])
        params = {
          category_ids:,
          new_categories:,
        }

        response = post("categories/group/#{group_id}/add", params)

        handle_api_response(response) do |body|
          LunchMoney::Objects::Category.new(**body)
        end
      end

      def delete_category(category_id)
        response = delete("categories/#{category_id}")

        handle_api_response(response) do |body|
          body
        end
      end

      def force_delete_category(category_id)
        response = delete("categories/#{category_id}/force")

        handle_api_response(response) do |body|
          body
        end
      end

      private

      def categories_params(format:)
        return unless format

        raise(InvalidQueryParameter, "format must be either flattened or nested") if VALID_FORMATS.exclude?(format.to_s)

        { format: format.to_s }
      end
    end
  end
end
