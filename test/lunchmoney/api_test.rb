# typed: strict
# frozen_string_literal: true

require "test_helper"

class ApiTest < ActiveSupport::TestCase
  test "api_key can be overwritten via kwarg" do
    LunchMoney::Configuration.any_instance.stubs(:api_key).returns("test_token")

    api = LunchMoney::Api.new(api_key: "new_test_token")

    assert_equal("test_token", LunchMoney.configuration.api_key)
    assert_equal("new_test_token", api.api_key)
  end

  test "api_key defaults to config value when no kwarg is passed" do
    LunchMoney::Configuration.any_instance.stubs(:api_key).returns("test_token")

    assert_equal("test_token", LunchMoney.configuration.api_key)
  end

  test "all asset instance methods are delegated" do
    asset_instance_methods = LunchMoney::Calls::Assets.instance_methods(false)

    assert_empty(asset_instance_methods - api_instance_methods)
  end

  test "all budget instance methods are delegated" do
    budget_instance_methods = LunchMoney::Calls::Budgets.instance_methods(false)

    assert_empty(budget_instance_methods - api_instance_methods)
  end

  test "all category instance methods are delegated" do
    category_instance_methods = LunchMoney::Calls::Categories.instance_methods(false)

    assert_empty(category_instance_methods - api_instance_methods)
  end

  test "all crypto instance methods are delegated" do
    crypto_instance_methods = LunchMoney::Calls::Crypto.instance_methods(false)

    assert_empty(crypto_instance_methods - api_instance_methods)
  end

  test "all plaid_account instance methods are delegated" do
    plaid_account_instance_methods = LunchMoney::Calls::PlaidAccounts.instance_methods(false)

    assert_empty(plaid_account_instance_methods - api_instance_methods)
  end

  test "all recurring_expense instance methods are delegated" do
    recurring_expense_instance_methods = LunchMoney::Calls::RecurringExpenses.instance_methods(false)

    assert_empty(recurring_expense_instance_methods - api_instance_methods)
  end

  test "all tag instance methods are delegated" do
    tag_instance_methods = LunchMoney::Calls::Tags.instance_methods(false)

    assert_empty(tag_instance_methods - api_instance_methods)
  end

  test "all transaction instance methods are delegated" do
    transaction_instance_methods = LunchMoney::Calls::Transactions.instance_methods(false)

    assert_empty(transaction_instance_methods - api_instance_methods)
  end

  test "all user instance methods are delegated" do
    user_instance_methods = LunchMoney::Calls::Users.instance_methods(false)

    assert_empty(user_instance_methods - api_instance_methods)
  end

  [
    :asset_calls,
    :budget_calls,
    :category_calls,
    :crypto_calls,
    :plaid_account_calls,
    :recurring_expense_calls,
    :tag_calls,
    :transaction_calls,
    :user_calls,
  ].each do |call|
    test "error is raised if api_key is nil for #{call}" do
      T.bind(self, ApiTest)
      LunchMoney::Configuration.any_instance.stubs(:api_key).returns(nil)

      error = assert_raises(LunchMoney::InvalidApiKey) do
        LunchMoney::Api.new.send(call)
      end

      assert_equal("API key is missing or invalid", error.message)
    end

    test "error is raised if api_key is empty string for #{call}" do
      T.bind(self, ApiTest)
      LunchMoney::Configuration.any_instance.stubs(:api_key).returns("")

      error = assert_raises(LunchMoney::InvalidApiKey) do
        LunchMoney::Api.new.send(call)
      end

      assert_equal("API key is missing or invalid", error.message)
    end

    test "error is not raised if api_key is not empty or nil for #{call}" do
      T.bind(self, ApiTest)
      LunchMoney::Configuration.any_instance.stubs(:api_key).returns("this_could_maybe_be_a_token")

      assert_nothing_raised do
        LunchMoney::Api.new.send(call)
      end
    end
  end

  test "error is raised if no api_key is nil for asset call" do
    api = LunchMoney::Api.new(api_key: "")

    assert_raises(LunchMoney::InvalidApiKey) do
      api.asset_calls
    end
  end

  private

  sig { returns(T::Array[Symbol]) }
  def api_instance_methods
    LunchMoney::Api.instance_methods(false)
  end
end
