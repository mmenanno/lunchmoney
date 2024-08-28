# typed: strict
# frozen_string_literal: true

module LunchMoney
  module Deprecate
    cattr_accessor :endpoint_deprecation_warnings, default: true

    sig { params(replacement: T.nilable(String)).void }
    def deprecate_endpoint(replacement = nil)
      return unless endpoint_deprecation_warnings

      replacement = if replacement.nil?
        "There is currently no replacement for this endpoint"
      else
        "Please use #{replacement} instead"
      end

      message = "#{deprecated_endpoint} is deprecated and may be removed from LunchMoney | #{replacement}"
      Kernel.warn(message)
    end

    private

    sig { returns(String) }
    def deprecated_endpoint
      endpoint_call = Kernel.caller_locations.find { |call| call.to_s.include?("lunchmoney/calls") }

      if endpoint_call.nil?
        ""
      else
        "LunchMoney::Api##{endpoint_call.label}"
      end
    end
  end
end
