# frozen_string_literal: true

module LunchMoney
  # This class is used to represent errors returned directly from the LunchMoney API. This class has been set up to act
  # like an array, delegating a lot of common array getter methods directly to messages for you.
  # @example
  #   api = LunchMoney::Api.new
  #   response = api.categories
  #
  #   response.class
  #   => LunchMoney::Errors
  #
  #   response.first
  #   => "Some error returned by the API"
  #
  #   response.empty?
  #   => false
  #
  #   response[0]
  #   => "Some error returned by the API"
  class Errors
    attr_accessor :messages

    def initialize(message: nil)
      @messages = []

      @messages << message unless message.nil?
    end

    delegate :[], :<<, :each, :to_a, :first, :last, :empty?, :present?, to: :@messages
  end
end
