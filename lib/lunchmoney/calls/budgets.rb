# typed: strict
# frozen_string_literal: true

require_relative "../objects/budget"

module LunchMoney
  module Calls
    # https://lunchmoney.dev/#budget
    class Budgets < LunchMoney::Calls::Base
      sig do
        params(
          start_date: String,
          end_date: String,
          currency: T.nilable(String),
        ).returns(T.any(T::Array[LunchMoney::Objects::Budget], LunchMoney::Errors))
      end
      def budgets(start_date:, end_date:, currency: nil)
        params = clean_params({ start_date:, end_date:, currency: })
        response = get("budgets", query_params: params)

        handle_api_response(response) do |body|
          body.map do |budget|
            if budget[:data]
              data_keys = budget[:data].keys
              data_keys.each do |data_key|
                budget[:data][data_key] = LunchMoney::Objects::Data.new(**budget[:data][data_key])
              end
            end

            if budget[:config]
              config_keys = budget[:config].keys
              config_keys.each do |config_key|
                budget[:config][config_key] = LunchMoney::Objects::Data.new(**budget[:config][config_key])
              end
            end

            if budget[:recurring]
              budget[:recurring][:list]&.map! { |recurring| LunchMoney::Objects::RecurringExpenseBase.new(**recurring) }
            end

            LunchMoney::Objects::Budget.new(**budget)
          end
        end
      end

      sig do
        params(
          start_date: String,
          category_id: Integer,
          amount: Number,
          currency: T.nilable(String),
        ).returns(T.any(
          T::Hash[Symbol, { category_id: Integer, amount: Number, currency: String, start_date: String }],
          LunchMoney::Errors,
        ))
      end
      def upsert_budget(start_date:, category_id:, amount:, currency: nil)
        params = clean_params({ start_date:, category_id:, amount:, currency: })
        response = put("budgets", params)

        handle_api_response(response) do |body|
          body
        end
      end

      sig { params(start_date: String, category_id: Integer).returns(T.any(T::Boolean, LunchMoney::Errors)) }
      def remove_budget(start_date:, category_id:)
        params = {
          start_date:,
          category_id:,
        }

        response = delete("budgets", query_params: params)

        handle_api_response(response) do |body|
          body
        end
      end
    end
  end
end
