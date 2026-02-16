# frozen_string_literal: true

require_relative "transaction_modification_base"

module LunchMoney
  module Objects
    # object used when updating a transaction https://lunchmoney.dev/#update-transaction
    class UpdateTransaction < TransactionModificationBase
      attr_accessor :amount, :currency, :status, :external_id

      attr_accessor :asset_id, :recurring_id

      attr_accessor :tags

      def initialize(tags: nil, category_id: nil, payee: nil, amount: nil, currency: nil, asset_id: nil,
        recurring_id: nil, notes: nil, status: nil, external_id: nil, date: nil)
        super(payee:, date:, category_id:, notes:)
        @amount = amount
        @tags = tags
        @currency = currency
        @asset_id = asset_id
        @recurring_id = recurring_id
        @status = status
        @external_id = external_id
      end
    end
  end
end
