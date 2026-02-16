# frozen_string_literal: true

require_relative "transaction_base"

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#transaction-object
    class Transaction < TransactionBase
      attr_accessor :category_id,
        :category_group_id,
        :recurring_id,
        :parent_id,
        :group_id,
        :external_id

      attr_accessor :created_at,
        :updated_at,
        :status,
        :source,
        :display_name,
        :account_display_name

      attr_accessor :category_name,
        :category_group_name,
        :original_name,
        :recurring_payee,
        :recurring_description,
        :recurring_cadence,
        :recurring_type,
        :recurring_amount,
        :recurring_currency,
        :asset_institution_name,
        :asset_name,
        :asset_display_name,
        :asset_status,
        :plaid_account_name,
        :plaid_account_mask,
        :institution_name,
        :plaid_account_display_name,
        :plaid_metadata,
        :display_notes

      attr_accessor :is_income, :exclude_from_budget, :exclude_from_totals, :is_pending, :has_children, :is_group

      attr_accessor :tags

      attr_accessor :children

      # TODO: Fix types when I have a response on what they should be https://github.com/mmenanno/lunchmoney/issues/329
      attr_accessor :recurring_granularity, :recurring_quantity

      def initialize(id:, date:, amount:, currency:, to_base:, payee:, is_income:, exclude_from_budget:,
        exclude_from_totals:, created_at:, updated_at:, status:, is_pending:, has_children:, is_group:, source:,
        display_name:, account_display_name:, tags:, category_id: nil, category_name: nil, category_group_id: nil,
        category_group_name: nil, notes: nil, original_name: nil, recurring_id: nil, recurring_payee: nil,
        recurring_description: nil, recurring_cadence: nil, recurring_type: nil, recurring_amount: nil,
        recurring_currency: nil, parent_id: nil, group_id: nil, asset_id: nil, asset_institution_name: nil,
        asset_name: nil, asset_display_name: nil, asset_status: nil, plaid_account_id: nil, plaid_account_name: nil,
        plaid_account_mask: nil, institution_name: nil, plaid_account_display_name: nil, plaid_metadata: nil,
        display_notes: nil, external_id: nil, children: nil, recurring_granularity: nil, recurring_quantity: nil)
        super(id:, date:, amount:, currency:, to_base:, payee:, notes:, asset_id:, plaid_account_id:)
        @is_income = is_income
        @exclude_from_budget = exclude_from_budget
        @exclude_from_totals = exclude_from_totals
        @created_at = created_at
        @updated_at = updated_at
        @status = status
        @is_pending = is_pending
        @has_children = has_children
        @is_group = is_group
        @source = source
        @display_name = display_name
        @account_display_name = account_display_name
        @tags = tags
        @category_id = category_id
        @category_name = category_name
        @category_group_id = category_group_id
        @category_group_name = category_group_name
        @original_name = original_name
        @recurring_id = recurring_id
        @recurring_payee = recurring_payee
        @recurring_description = recurring_description
        @recurring_cadence = recurring_cadence
        @recurring_type = recurring_type
        @recurring_amount = recurring_amount
        @recurring_currency = recurring_currency
        @parent_id = parent_id
        @group_id = group_id
        @asset_institution_name = asset_institution_name
        @asset_name = asset_name
        @asset_display_name = asset_display_name
        @asset_status = asset_status
        @plaid_account_name = plaid_account_name
        @plaid_account_mask = plaid_account_mask
        @institution_name = institution_name
        @plaid_account_display_name = plaid_account_display_name
        @plaid_metadata = plaid_metadata
        @display_notes = display_notes
        @children = children
        @external_id = external_id
        @recurring_granularity = recurring_granularity
        @recurring_quantity = recurring_quantity
      end
    end
  end
end
