# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "struct"

module LunchMoney
  class Split < T::Struct
    prop :date, String
    prop :category_id, Integer
    prop :notes, T.nilable(String)
    prop :amount, T.any(Integer, String)
  end
end
