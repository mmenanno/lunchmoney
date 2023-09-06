# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Transaction < T::Struct
    prop :id, T.nilable(Integer)
    prop :date, T.nilable(String)
    prop :payee, T.nilable(String)
    prop :amount, T.nilable(String)
    prop :currency, T.nilable(String)
    prop :to_base, T.nilable(Integer)
    prop :notes, T.nilable(String)
    prop :category_id, T.nilable(Integer)
    prop :recurring_id, T.nilable(Integer)
    prop :asset_id, T.nilable(Integer)
    prop :plaid_account_id, T.nilable(Integer)
    prop :status, T.nilable(String)
    prop :parent_id, T.nilable(Integer)
    prop :is_group, T.nilable(T::Boolean)
    prop :group_id, T.nilable(Integer)
    prop :tags, T.nilable(T::Array[LunchMoney::Tag])
    prop :external_id, T.nilable(String)
    prop :original_name, T.nilable(String)
    prop :type, T.nilable(String)
    prop :subtype, T.nilable(String)
    prop :fees, T.nilable(String)
    prop :price, T.nilable(String)
    prop :quantity, T.nilable(String)
  end
end
