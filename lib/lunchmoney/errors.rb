# typed: strict
# frozen_string_literal: true

module LunchMoney
  # This class is used to represent errors returned directly from the LunchMoney API
  class Errors
    sig { returns(T::Array[String]) }
    attr_accessor :messages

    sig { params(message: T.nilable(String)).void }
    def initialize(message: nil)
      @messages = T.let([], T::Array[String])

      @messages << message unless message.nil?
    end

    delegate :[], :<<, :each, :to_a, :first, :last, :empty?, :present?, to: :@messages
  end
end
