# typed: strict
# frozen_string_literal: true

module ConfigurationHelper
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

  sig { params(replacement_environment: T::Hash[String, String], block: T.proc.void).void }
  def with_environment(replacement_environment, &block)
    original_environment = ENV.to_hash
    ENV.update(replacement_environment)

    yield
  ensure
    ENV.replace(T.must(original_environment))
  end

  sig { params(block: T.proc.void).void }
  def with_safe_api_key_changes(&block)
    original_api_key = LunchMoney.configuration.api_key

    yield
  ensure
    LunchMoney.configuration.api_key = original_api_key
  end
end
