# frozen_string_literal: true

module ConfigurationHelper
  private

  def with_environment(replacement_environment, &block)
    original_environment = ENV.to_hash
    ENV.update(replacement_environment)
    yield
  ensure
    ENV.replace(original_environment)
  end

  def with_safe_api_key_changes(&block)
    original_api_key = LunchMoney.configuration.api_key
    yield
  ensure
    LunchMoney.configuration.api_key = original_api_key
  end
end
