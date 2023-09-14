# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Exception < StandardError; end

  class InvalidApiKey < Exception; end
end
