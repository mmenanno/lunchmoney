# typed: strict
# frozen_string_literal: true

module LunchMoney
  # Base exception class for exceptions raised by this gem
  class Exception < StandardError; end

  # Exception raised when an API Key appears to be invalid
  class InvalidApiKey < Exception; end

  # Exception raised when an object attribute is invalid
  class InvalidObjectAttribute < Exception; end

  # Exception raised when a query parameter is invalid
  class InvalidQueryParameter < Exception; end

  # Exception raised when an essential argument is missing
  class MissingArgument < Exception; end
end
