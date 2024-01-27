# typed: strict
# frozen_string_literal: true

module EnvironmentHelper
  sig { params(replacement_environment: T::Hash[String, String], block: T.proc.void).void }
  def with_environment(replacement_environment, &block)
    original_environment = ENV.to_hash
    ENV.update(replacement_environment)

    yield
  ensure
    ENV.replace(T.must(original_environment))
  end
end
