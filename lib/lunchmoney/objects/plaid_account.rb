# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "struct"

module LunchMoney
  class PlaidAccount < T::Struct
    prop :id, Integer
    prop :date_linked, String
    prop :name, String
    prop :type, String
    prop :subtype, T.nilable(String)
    prop :mask, String
    prop :institution_name, String
    prop :status, String
    prop :last_import, String
    prop :balance, String
    prop :currency, String
    prop :balance_last_update, String
    prop :limit, T.nilable(Integer)
  end
end
