# typed: strict
# frozen_string_literal: true

require_relative "../categories/category/category"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#categories
    class Categories < LunchMoney::Calls::Base
      # Valid query parameter formets for categories
      VALID_FORMATS = T.let(
        [
          "flattened",
          "nested",
        ],
        T::Array[String],
      )

      sig do
        params(
          format: T.nilable(T.any(String, Symbol)),
        ).returns(T.any(T::Array[LunchMoney::Category], LunchMoney::Errors))
      end
      def categories(format: nil)
        response = get("categories", query_params: categories_params(format:))

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body[:categories].map do |category|
          category[:children]&.map! { |child_category| LunchMoney::Category.new(**child_category) }

          LunchMoney::Category.new(**category)
        end
      end

      sig { params(category_id: Integer).returns(T.any(LunchMoney::Category, LunchMoney::Errors)) }
      def category(category_id)
        response = get("categories/#{category_id}")

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body[:children]&.map! { |child_category| LunchMoney::ChildCategory.new(**child_category) }

        LunchMoney::Category.new(**response.body)
      end

      sig do
        params(
          name: String,
          description: T.nilable(String),
          is_income: T::Boolean,
          exclude_from_budget: T::Boolean,
          exclude_from_totals: T::Boolean,
          archived: T::Boolean,
          group_id: T.nilable(Integer),
        ).returns(T.any(T::Hash[Symbol, Integer], LunchMoney::Errors))
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

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body
      end

      sig do
        params(
          name: String,
          description: T.nilable(String),
          is_income: T::Boolean,
          exclude_from_budget: T::Boolean,
          exclude_from_totals: T::Boolean,
          category_ids: T::Array[Integer],
          new_categories: T::Array[String],
        ).returns(T.any(T::Hash[Symbol, Integer], LunchMoney::Errors))
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

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body
      end

      sig do
        params(
          category_id: Integer,
          name: T.nilable(String),
          description: T.nilable(String),
          is_income: T.nilable(T::Boolean),
          exclude_from_budget: T.nilable(T::Boolean),
          exclude_from_totals: T.nilable(T::Boolean),
          archived: T.nilable(T::Boolean),
          group_id: T.nilable(Integer),
        ).returns(T.any(T::Boolean, LunchMoney::Errors))
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

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body
      end

      sig do
        params(
          group_id: Integer,
          category_ids: T::Array[Integer],
          new_categories: T::Array[String],
        ).returns(T.any(LunchMoney::Category, LunchMoney::Errors))
      end
      def add_to_category_group(group_id, category_ids: [], new_categories: [])
        params = {
          category_ids:,
          new_categories:,
        }

        response = post("categories/group/#{group_id}/add", params)

        api_errors = errors(response)
        return api_errors if api_errors.present?

        LunchMoney::Category.new(**response.body)
      end

      sig { params(category_id: Integer).returns(T.any(T::Boolean, LunchMoney::Errors)) }
      def delete_category(category_id)
        response = delete("categories/#{category_id}")

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body
      end

      sig { params(category_id: Integer).returns(T.any(T::Boolean, LunchMoney::Errors)) }
      def force_delete_category(category_id)
        response = delete("categories/#{category_id}/force")

        api_errors = errors(response)
        return api_errors if api_errors.present?

        response.body
      end

      private

      sig { params(format: T.nilable(T.any(String, Symbol))).returns(T.nilable(T::Hash[Symbol, String])) }
      def categories_params(format:)
        return unless format

        raise(InvalidQueryParameter, "format must be either flattened or nested") if VALID_FORMATS.exclude?(format.to_s)

        { format: format.to_s }
      end
    end
  end
end
