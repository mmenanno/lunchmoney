# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

require "json"

module LunchMoney
  module Objects
    class UpdateManualAccount < Base
      attr_accessor :id, :name, :institution_name, :display_name, :type, :subtype, :balance,
                    :currency, :balance_as_of, :status, :closed_on, :external_id,
                    :custom_metadata, :exclude_from_transactions, :to_base,
                    :created_at, :updated_at, :created_by_name

      def validate!
        raise LunchMoney::ClientValidationError, "name must be at most 45 characters" if name && name.to_s.length > 45
        raise LunchMoney::ClientValidationError, "name must be at least 1 characters" if name && name.to_s.length < 1
        raise LunchMoney::ClientValidationError, "institution_name must be at most 50 characters" if institution_name && institution_name.to_s.length > 50
        raise LunchMoney::ClientValidationError, "institution_name must be at least 1 characters" if institution_name && institution_name.to_s.length < 1
        raise LunchMoney::ClientValidationError, "subtype must be at most 100 characters" if subtype && subtype.to_s.length > 100
        raise LunchMoney::ClientValidationError, "subtype must be at least 1 characters" if subtype && subtype.to_s.length < 1
        raise LunchMoney::ClientValidationError, "status must be one of: active, closed" if status && !["active", "closed"].include?(status)
        raise LunchMoney::ClientValidationError, "external_id must be at most 75 characters" if external_id && external_id.to_s.length > 75
        if custom_metadata && !custom_metadata.is_a?(Hash)
          raise LunchMoney::ClientValidationError, "custom_metadata must be a Hash"
        end
        if custom_metadata && JSON.generate(custom_metadata).length > 4096
          raise LunchMoney::ClientValidationError, "custom_metadata exceeds 4096 character limit"
        end
      end
    end
  end
end
