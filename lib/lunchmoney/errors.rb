# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Error < StandardError; end

  class InvalidApiKey < Error; end
end
