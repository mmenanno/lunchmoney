# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "struct"

module LunchMoney
  class Asset < T::Struct
    prop :id, Integer
    prop :type_name, String
    prop :subtype_name, T.nilable(String)
    prop :name, String
    prop :display_name, T.nilable(String)
    prop :balance, String
    prop :balance_as_of, String
    prop :closed_on, T.nilable(String)
    prop :currency, String
    prop :institution_name, T.nilable(String)
    prop :created_at, String
  end
end
