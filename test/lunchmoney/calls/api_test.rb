# frozen_string_literal: true

require "test_helper"

module LunchMoney
  module Calls
    class ApiTest < ActiveSupport::TestCase
      include LunchMoneyStubHelper
      include FixtureHelper

      setup do
        @api = LunchMoney::Api.new(api_key: "test_api_key")
      end

      test "Api.new creates an instance" do
        assert_instance_of LunchMoney::Api, @api
      end

      test "Api inherits from Client::Base" do
        assert_kind_of LunchMoney::Client::Base, @api
        assert LunchMoney::Api < LunchMoney::Client::Base
      end

      test "Api has rate_limit accessor" do
        assert_respond_to @api, :rate_limit
        assert_nil @api.rate_limit
      end

      test "Api responds to Calls::Me methods" do
        assert_respond_to @api, :me
      end

      test "Api responds to Calls::Categories methods" do
        %i[categories category create_category update_category delete_category].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::Tags methods" do
        %i[tags tag create_tag update_tag delete_tag].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::Transactions methods" do
        %i[transactions transactions_page transaction create_transaction create_transactions
           update_transaction delete_transaction].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::Transactions::Split methods" do
        %i[split_transaction unsplit_transaction].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::Transactions::Group methods" do
        %i[group_transactions ungroup_transactions].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::Transactions::Bulk methods" do
        %i[update_transactions delete_transactions].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::Transactions::Attachments methods" do
        %i[attachments attach_file attachment_url delete_attachment].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::ManualAccounts methods" do
        %i[manual_accounts manual_account create_manual_account update_manual_account
           delete_manual_account].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::PlaidAccounts methods" do
        %i[plaid_accounts plaid_account plaid_accounts_fetch].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::RecurringItems methods" do
        %i[recurring_items recurring_item].each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end

      test "Api responds to Calls::Summary methods" do
        assert_respond_to @api, :summary
      end

      test "Api responds to all expected public methods" do
        expected_methods = %i[
          me
          categories category create_category update_category delete_category
          tags tag create_tag update_tag delete_tag
          transactions transactions_page transaction
          create_transaction create_transactions update_transaction delete_transaction
          split_transaction unsplit_transaction
          group_transactions ungroup_transactions
          update_transactions delete_transactions
          attachments attach_file attachment_url delete_attachment
          manual_accounts manual_account create_manual_account update_manual_account delete_manual_account
          plaid_accounts plaid_account plaid_accounts_fetch
          recurring_items recurring_item
          summary
        ]

        expected_methods.each do |method|
          assert_respond_to @api, method, "Expected Api to respond to #{method}"
        end
      end
    end
  end
end
