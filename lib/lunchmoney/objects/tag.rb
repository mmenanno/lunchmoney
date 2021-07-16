# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require_relative "struct"

module LunchMoney
  extend T::Sig
  class Tag < T::Struct
    prop :id, Integer
    prop :name, String
    prop :description, T.nilable(String)
  end
end
