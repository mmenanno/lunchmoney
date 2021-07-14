# frozen_string_literal: true

module LunchMoney
  class Error < StandardError; end
  class ValidateError < Error ; end
  class GeneralError < Error ; end
  class UnRecognizedError < Error ; end
end
