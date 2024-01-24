# typed: strict
# frozen_string_literal: true

module LunchMoney
  # https://lunchmoney.dev/#user-object
  class User < LunchMoney::DataObject
    sig { returns(Integer) }
    attr_accessor :user_id, :account_id

    sig { returns(String) }
    attr_accessor :user_name, :user_email, :budget_name

    sig { returns(T.nilable(String)) }
    attr_accessor :api_key_label

    sig do
      params(
        user_id: Integer,
        user_name: String,
        user_email: String,
        account_id: Integer,
        budget_name: String,
        api_key_label: T.nilable(String),
      ).void
    end
    def initialize(user_id:, user_name:, user_email:, account_id:, budget_name:, api_key_label: nil)
      super()
      @user_id = user_id
      @user_name = user_name
      @user_email = user_email
      @account_id = account_id
      @budget_name = budget_name
      @api_key_label = api_key_label
    end
  end
end
