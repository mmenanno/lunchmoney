# typed: strict
# frozen_string_literal: true

module LunchMoney
  module Deprecate
    cattr_accessor :endpoint_deprecation_warnings, default: true

    sig { params(replacement: T.nilable(String), level: Symbol).void }
    def deprecate_endpoint(replacement = nil, level: :warning)
      return unless endpoint_deprecation_warnings
      return if ENV["SILENCE_LUNCHMONEY_DEPRECATIONS"] == "true"

      replacement_message = if replacement.nil?
        "There is currently no replacement for this endpoint"
      else
        "Please use #{replacement} instead"
      end

      endpoint_name = deprecated_endpoint
      message = "#{endpoint_name} is deprecated and may be removed from LunchMoney | #{replacement_message}"

      log_deprecation(message, level, endpoint_name, replacement)
    end

    private

    sig { returns(String) }
    def deprecated_endpoint
      # Look through the call stack to find the actual method that contains deprecate_endpoint
      # Skip internal framework methods and find the real caller
      Kernel.caller_locations.each_with_index do |location, index|
        label = location.label
        next if label.nil?
        next if label.include?("validator") # Skip Sorbet validators
        next if label.include?("CallValidation") # Skip Sorbet call validation
        next if label.include?("bind_call") # Skip method binding
        next if label.include?("validate_call") # Skip validation calls
        next if label == "deprecate_endpoint" # Skip our own method
        next if label == "deprecated_endpoint" # Skip this method
        next if label == "log_deprecation" # Skip logging method
        next if label.include?("block") && index < 8 # Skip nearby blocks
        next if location.path&.include?("sorbet-runtime") # Skip sorbet runtime
        next if location.path&.include?("gems") && index < 8 # Skip gem internals

        # Found a real method name - clean it up
        method_name = label
        method_name = method_name.split("#").last if method_name.include?("#")
        return "LunchMoney::Api##{method_name}"
      end

      # Fallback if we can't find a good method name
      "LunchMoney::Api#<unknown_method>"
    end

    sig { params(message: String, level: Symbol, endpoint: String, replacement: T.nilable(String)).void }
    def log_deprecation(message, level, endpoint, replacement)
      prefixed_message = case level
      when :error
        "[ERROR] #{message}"
      when :warning
        "[WARNING] #{message}"
      when :info
        "[INFO] #{message}"
      else
        "[WARNING] #{message}"
      end

      Kernel.warn(prefixed_message)
    end
  end
end
