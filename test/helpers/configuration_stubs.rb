# typed: strict
# frozen_string_literal: true

module ConfigurationStubs
  private

  sig { void }
  def should_validate_object_attributes
    LunchMoney.configuration.expects(:validate_object_attributes).returns(true).at_least_once
  end

  sig { void }
  def should_not_validate_object_attributes
    LunchMoney.configuration.expects(:validate_object_attributes).returns(false).at_least_once
  end

  sig { void }
  def remove_validate_object_attributes_expectation
    LunchMoney.configuration.unstub(:validate_object_attributes)
  end
end
