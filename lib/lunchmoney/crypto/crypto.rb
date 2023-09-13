# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Crypto < T::Struct
    prop :id, T.nilable(Integer)
    prop :zabo_account_id, T.nilable(Integer)
    prop :source, String
    prop :name, String
    prop :display_name, T.nilable(String)
    prop :balance, String
    prop :balance_as_of, String
    prop :currency, String
    prop :status, String
    prop :institution_name, String
    prop :created_at, String
  end
end
