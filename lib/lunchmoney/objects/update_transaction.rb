# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

require "json"

module LunchMoney
  module Objects
    class UpdateTransaction < Base
      attr_accessor :id, :date, :amount, :currency, :recurring_id, :payee, :original_name,
                    :category_id, :notes, :manual_account_id, :plaid_account_id,
                    :tag_ids, :additional_tag_ids, :external_id,
                    :custom_metadata, :status, :to_base, :is_pending,
                    :plaid_metadata, :created_at, :updated_at, :is_split_parent,
                    :children, :split_parent_id, :is_group_parent,
                    :group_parent_id, :source

      def validate!
        raise LunchMoney::ClientValidationError, "payee must be at most 140 characters" if payee && payee.to_s.length > 140
        raise LunchMoney::ClientValidationError, "original_name must be at most 140 characters" if original_name && original_name.to_s.length > 140
        raise LunchMoney::ClientValidationError, "notes must be at most 350 characters" if notes && notes.to_s.length > 350
        raise LunchMoney::ClientValidationError, "external_id must be at most 75 characters" if external_id && external_id.to_s.length > 75
        if custom_metadata && !custom_metadata.is_a?(Hash)
          raise LunchMoney::ClientValidationError, "custom_metadata must be a Hash"
        end
        if custom_metadata && JSON.generate(custom_metadata).length > 4096
          raise LunchMoney::ClientValidationError, "custom_metadata exceeds 4096 character limit"
        end
        raise LunchMoney::ClientValidationError, "status must be one of: reviewed, unreviewed" if status && !["reviewed", "unreviewed"].include?(status)
        raise LunchMoney::ClientValidationError, "source must be one of: api, csv, manual, merge, plaid, recurring, rule, split, user" if source && !["api", "csv", "manual", "merge", "plaid", "recurring", "rule", "split", "user"].include?(source)
      end
    end
  end
end
