# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Error < StandardError; end

  class ValidateError < Error; end

  class CategoryError < Error; end

  class OperationError < Error; end

  class MissingDateError < Error; end

  class UnknownTransactionError < Error; end

  class MultipleIssuesError < Error; end

  class InvalidDateError < Error; end

  class BudgetAmountError < Error; end

  class GeneralError < Error; end
end
