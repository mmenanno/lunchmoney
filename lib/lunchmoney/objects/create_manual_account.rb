# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

require "json"

module LunchMoney
  module Objects
    class CreateManualAccount < Base
      attr_accessor :name, :institution_name, :display_name, :type, :subtype, :balance,
                    :balance_as_of, :currency, :status, :closed_on, :external_id,
                    :custom_metadata, :exclude_from_transactions

      def validate!
        raise ArgumentError, "name is required" if name.nil?
        raise ArgumentError, "type is required" if type.nil?
        raise ArgumentError, "balance is required" if balance.nil?
        raise ArgumentError, "name must be at most 45 characters" if name && name.to_s.length > 45
        raise ArgumentError, "name must be at least 1 characters" if name && name.to_s.length < 1
        raise ArgumentError, "institution_name must be at most 50 characters" if institution_name && institution_name.to_s.length > 50
        raise ArgumentError, "institution_name must be at least 1 characters" if institution_name && institution_name.to_s.length < 1
        raise ArgumentError, "subtype must be at most 100 characters" if subtype && subtype.to_s.length > 100
        raise ArgumentError, "subtype must be at least 1 characters" if subtype && subtype.to_s.length < 1
        raise ArgumentError, "status must be one of: active, closed" if status && !["active", "closed"].include?(status)
        raise ArgumentError, "external_id must be at most 75 characters" if external_id && external_id.to_s.length > 75
        if custom_metadata && !custom_metadata.is_a?(Hash)
          raise ArgumentError, "custom_metadata must be a Hash"
        end
        if custom_metadata && JSON.generate(custom_metadata).length > 4096
          raise ArgumentError, "custom_metadata exceeds 4096 character limit"
        end
      end
    end
  end
end
