# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#user-object
    class User < LunchMoney::Objects::Object
      attr_accessor :user_id, :account_id

      attr_accessor :user_name, :user_email, :budget_name

      attr_accessor :api_key_label

      def initialize(user_id:, user_name:, user_email:, account_id:, budget_name:, primary_currency:,
        api_key_label: nil)
        super()
        @user_id = user_id
        @user_name = user_name
        @user_email = user_email
        @account_id = account_id
        @budget_name = budget_name
        @primary_currency = primary_currency
        @api_key_label = api_key_label
      end
    end
  end
end
