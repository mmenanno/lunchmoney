# typed: strict
# frozen_string_literal: true

module LunchMoney
  class User < T::Struct
    prop :user_id, Integer
    prop :user_name, String
    prop :user_email, String
    prop :account_id, Integer
    prop :budget_name, String
    prop :api_key_label, T.nilable(String)
  end
end
