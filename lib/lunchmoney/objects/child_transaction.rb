# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    class ChildTransaction < Base
      attr_accessor :id, :date, :amount, :currency, :to_base, :recurring_id, :payee, :original_name,
                    :category_id, :notes, :status, :is_pending, :created_at,
                    :updated_at, :is_split_parent, :split_parent_id,
                    :is_group_parent, :group_parent_id, :manual_account_id,
                    :plaid_account_id, :tag_ids, :source, :external_id,
                    :plaid_metadata, :custom_metadata, :files

      def category(client:)
        return nil unless category_id
        hydrate(:category, client: client) { |c| c.category(category_id) }
      end

      def manual_account(client:)
        return nil unless manual_account_id
        hydrate(:manual_account, client: client) { |c| c.manual_account(manual_account_id) }
      end

      def plaid_account(client:)
        return nil unless plaid_account_id
        hydrate(:plaid_account, client: client) { |c| c.plaid_account(plaid_account_id) }
      end

      def tags(client:)
        return [] if tag_ids.nil? || tag_ids.empty?
        hydrate(:tags, client: client) { |c| tag_ids.map { |id| c.tag(id) } }
      end
    end
  end
end
