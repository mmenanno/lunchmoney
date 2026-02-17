# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    module TransactionsSubmodules
      class SplitTest < ActiveSupport::TestCase
        include LunchMoneyStubHelper
        include FixtureHelper

        setup do
          @api = LunchMoney::Api.new(api_key: "test_api_key")
        end

        test "split_transaction returns array of Transaction objects" do
          split_fixture = fixture("transactions/split/create_split_8845_transaction")
          children = split_fixture[:children]
          stub_lunchmoney(:post, "/transactions/split/2112150650",
            body: { transactions: children })

          result = @api.split_transaction(2112150650, [
            { amount: "44.23", payee: "Food Town - Lenny" },
            { amount: "44.22", payee: "Food Town - Penny" },
          ])

          assert_kind_of Array, result
          assert_equal 2, result.length
          result.each do |txn|
            assert_kind_of LunchMoney::Objects::Transaction, txn
          end
          assert_equal 2112150750, result.first.id
          assert_equal "Food Town - Lenny", result.first.payee
        end

        test "split_transaction raises ClientValidationError for missing amount" do
          assert_raises(LunchMoney::ClientValidationError) do
            @api.split_transaction(123, [{ payee: "Split 1" }])
          end
        end

        test "unsplit_transaction returns nil on 204" do
          stub_lunchmoney(:delete, "/transactions/split/2112150650", status: 204, body: nil)

          result = @api.unsplit_transaction(2112150650)

          assert_nil result
        end
      end

      class GroupTest < ActiveSupport::TestCase
        include LunchMoneyStubHelper
        include FixtureHelper

        setup do
          @api = LunchMoney::Api.new(api_key: "test_api_key")
        end

        test "group_transactions returns a Transaction object" do
          stub_lunchmoney(:post, "/transactions/group",
            response: "transactions/group/group_group_inherits_category")

          result = @api.group_transactions(
            transaction_ids: [2112140365, 2112140361],
            date: "2024-12-10",
            payee: "Home Entertainment Transactions",
          )

          assert_kind_of LunchMoney::Objects::Transaction, result
          assert_equal 123456789, result.id
          assert_equal "Home Entertainment Transactions", result.payee
          assert_equal true, result.is_group_parent
        end

        test "ungroup_transactions returns nil on 204" do
          stub_lunchmoney(:delete, "/transactions/group/123456789", status: 204, body: nil)

          result = @api.ungroup_transactions(123456789)

          assert_nil result
        end
      end

      class BulkTest < ActiveSupport::TestCase
        include LunchMoneyStubHelper
        include FixtureHelper

        setup do
          @api = LunchMoney::Api.new(api_key: "test_api_key")
        end

        test "update_transactions returns array of Transaction objects" do
          stub_lunchmoney(:put, "/transactions",
            response: "transactions/bulk_update_bulk_update_transactions")

          result = @api.update_transactions([
            { id: 2112150654, category_id: 315162, notes: "Treat restaurants the same as groceries" },
            { id: 2112150649, category_id: 315162, notes: "Treat restaurants the same as groceries" },
            { id: 2112140372, category_id: 315162, notes: "Treat restaurants the same as groceries" },
          ])

          assert_kind_of Array, result
          assert_equal 3, result.length
          result.each do |txn|
            assert_kind_of LunchMoney::Objects::Transaction, txn
          end
        end

        test "delete_transactions returns nil on 204" do
          stub_lunchmoney(:delete, "/transactions?ids%5B%5D=111&ids%5B%5D=222&ids%5B%5D=333",
            status: 204, body: nil)

          result = @api.delete_transactions([111, 222, 333])

          assert_nil result
        end
      end

      class AttachmentsTest < ActiveSupport::TestCase
        include LunchMoneyStubHelper
        include FixtureHelper

        setup do
          @api = LunchMoney::Api.new(api_key: "test_api_key")
        end

        test "attachments returns array of TransactionAttachment objects" do
          attachment_data = fixture("transactions/attachments/create")
          stub_lunchmoney(:get, "/transactions/123/attachments",
            body: { attachments: [attachment_data] })

          result = @api.attachments(transaction_id: 123)

          assert_kind_of Array, result
          assert_equal 1, result.length
          assert_kind_of LunchMoney::Objects::TransactionAttachment, result.first
          assert_equal 1234567890, result.first.id
          assert_equal "receipt.png", result.first.name
        end

        test "attachment_url returns TransactionAttachment" do
          stub_lunchmoney(:get, "/transactions/attachments/1234567890",
            response: "transactions/attachments/get")

          result = @api.attachment_url(1234567890)

          assert_kind_of LunchMoney::Objects::TransactionAttachment, result
        end

        test "delete_attachment returns nil on 204" do
          stub_lunchmoney(:delete, "/transactions/attachments/1234567890", status: 204, body: nil)

          result = @api.delete_attachment(1234567890)

          assert_nil result
        end
      end
    end
  end
end
