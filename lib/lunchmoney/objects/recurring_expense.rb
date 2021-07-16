# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "struct"

module LunchMoney
  extend T::Sig
  class RecurringExpense < T::Struct
    prop :id, Integer
    prop :start_date, String
    prop :end_date, T.nilable(String)
    prop :cadence, String
    prop :payee, String
    prop :amount, Integer
    prop :currency, String
    prop :description, T.nilable(String)
    prop :billing_date, String
    prop :type, String
    prop :original_name, T.nilable(String)
    prop :source, String
    prop :plaid_account_id, T.nilable(Integer)
    prop :asset_id, T.nilable(Integer)
    prop :transaction_id, T.nilable(Integer)
    prop :category_id, T.nilable(Integer)
  end
end
