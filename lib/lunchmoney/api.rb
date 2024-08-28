# typed: strict
# frozen_string_literal: true

require_relative "exceptions"
require_relative "configuration"
require_relative "deprecate"

require_relative "calls/base"
require_relative "objects/object"
require_relative "calls/users"
require_relative "calls/categories"
require_relative "calls/tags"
require_relative "calls/transactions"
require_relative "calls/recurring_expenses"
require_relative "calls/budgets"
require_relative "calls/assets"
require_relative "calls/plaid_accounts"
require_relative "calls/crypto"

module LunchMoney
  # The main API class that a user should interface through. The method of any individual call is delegated through here
  # so that it is never necessary to go through things like `LunchMoney::Calls::Users.new.user` instead you can directly
  # call the endpoint with LunchMoney::Api.new.user and it will be delegated to the correct call.
  # @example
  #   api = LunchMoney::Api.new
  #   api.categories # This will be delegated to LunchMoney::Calls::Categories#categories
  class Api
    sig { returns(T.nilable(String)) }
    attr_reader :api_key

    sig { params(api_key: T.nilable(String)).void }
    def initialize(api_key: nil)
      @api_key = T.let((api_key || LunchMoney.configuration.api_key), T.nilable(String))
    end

    delegate :me, to: :user_calls

    # All [user call types](https://lunchmoney.dev/#user) come through here.
    # @example [Get User](https://lunchmoney.dev/#get-user)
    #   api = LunchMoney::Api.new
    #   api.me
    sig { returns(LunchMoney::Calls::Base) }
    def user_calls
      with_valid_api_key do
        @user_calls ||= T.let(LunchMoney::Calls::Users.new(api_key:), T.nilable(LunchMoney::Calls::Users))
      end
    end

    delegate :categories,
      :category,
      :create_category,
      :create_category_group,
      :update_category,
      :add_to_category_group,
      :delete_category,
      :force_delete_category,
      to: :category_calls

    # All [category call types](https://lunchmoney.dev/#categories) come through here. Reference the docs for
    # available parameters for each call
    # @example [Get All Categories](https://lunchmoney.dev/#get-all-categories)
    #   api = LunchMoney::Api.new
    #   api.categories
    # @example [Get Single Category](https://lunchmoney.dev/#get-single-category)
    #   api = LunchMoney::Api.new
    #   api.category(1234567)
    # @example [Create Category](https://lunchmoney.dev/#create-category)
    #   api = LunchMoney::Api.new
    #   api.create_category(name: "New Category Name")
    # @example [Create Category Group](https://lunchmoney.dev/#create-category-group)
    #   api = LunchMoney::Api.new
    #   api.create_category_group(name: "New Category Group Name")
    # @example [Update Category](https://lunchmoney.dev/#update-category)
    #   api = LunchMoney::Api.new
    #   api.update_category(1234567, "Updated Category Name")
    # @example [Add to Category Group](https://lunchmoney.dev/#add-to-category-group)
    #   api = LunchMoney::Api.new
    #   api.add_to_category_group(7654321, category_ids: [1234567], new_categories: ["Another Category"])
    # @example [Delete Category](https://lunchmoney.dev/#delete-category)
    #   api = LunchMoney::Api.new
    #   api.delete_category(1234567)
    # @example [Force Delete Category](https://lunchmoney.dev/#force-delete-category)
    #   api = LunchMoney::Api.new
    #   api.force_delete_category(1234567)
    sig { returns(LunchMoney::Calls::Base) }
    def category_calls
      with_valid_api_key do
        @category_calls ||= T.let(LunchMoney::Calls::Categories.new(api_key:), T.nilable(LunchMoney::Calls::Categories))
      end
    end

    delegate :tags, to: :tag_calls

    # All [tags call types](https://lunchmoney.dev/#tags) come through here.
    # @example [Get All Tags](https://lunchmoney.dev/#get-all-tags)
    #   api = LunchMoney::Api.new
    #   api.tags
    sig { returns(LunchMoney::Calls::Base) }
    def tag_calls
      with_valid_api_key do
        @tag_calls ||= T.let(LunchMoney::Calls::Tags.new(api_key:), T.nilable(LunchMoney::Calls::Tags))
      end
    end

    delegate :transactions,
      :transaction,
      :insert_transactions,
      :update_transaction,
      :unsplit_transaction,
      :transaction_group,
      :create_transaction_group,
      :delete_transaction_group,
      to: :transaction_calls

    # All [transaction call types](https://lunchmoney.dev/#transactions) come through here.
    # @example [Get All Transactions](https://lunchmoney.dev/#get-all-transactions)
    #   api = LunchMoney::Api.new
    #   api.transactions
    # @example [Get Single Transaction](https://lunchmoney.dev/#get-single-transaction)
    #   api = LunchMoney::Api.new
    #   api.transaction(123456789)
    # @example [Insert Transactions](https://lunchmoney.dev/#insert-transactions)
    #   api = LunchMoney::Api.new
    #   transaction = LunchMoney::Objects::UpdateTransaction.new(
    #     date: "2024-01-01",
    #     amount: "10.99",
    #     payee: "Example Payee",
    #     currency: "cad",
    #     status: "cleared"
    #   )
    #   api.insert_transactions([transaction])
    # @example Regular [Update Transactions](https://lunchmoney.dev/#update-transactions)
    #   api = LunchMoney::Api.new
    #   transaction = LunchMoney::Objects::UpdateTransaction.new(
    #     date: "2024-01-01",
    #     amount: "10.99",
    #     payee: "Example Payee",
    #     currency: "cad",
    #     status: "cleared"
    #   )
    #   api.update_transaction(123456789, transaction: transaction)
    # @example Split [Update Transactions](https://lunchmoney.dev/#update-transactions)
    #   api = LunchMoney::Api.new
    #   split = [
    #     LunchMoney::Objects::Split.new(amount: "10.00"),
    #     LunchMoney::Objects::Split.new(amount: "47.54"),
    #   ]
    #   api.update_transaction(12345678, split: split)
    # @example [Unsplit Transactions](https://lunchmoney.dev/#unsplit-transactions)
    #   api = LunchMoney::Api.new
    #   api.unsplit_transaction([123456789])
    # @example [Get Transaction Group](https://lunchmoney.dev/#get-transaction-group)
    #   api = LunchMoney::Api.new
    #   api.transaction_group(987654321)
    # @example [Create Transaction Group](https://lunchmoney.dev/#create-transaction-group)
    #   api = LunchMoney::Api.new
    #   api.create_transaction_group(date: "2024-01-01", payee: "Group", transactions: [123456789, 987654321])
    # @example [Delete Transaction Group](https://lunchmoney.dev/#delete-transaction-group)
    #   api = LunchMoney::Api.new
    #   api.delete_transaction_group(905483362)
    sig { returns(LunchMoney::Calls::Base) }
    def transaction_calls
      with_valid_api_key do
        @transaction_calls ||= T.let(
          LunchMoney::Calls::Transactions.new(api_key:),
          T.nilable(LunchMoney::Calls::Transactions),
        )
      end
    end

    delegate :recurring_expenses, to: :recurring_expense_calls

    # All [recurring expenses call types](https://lunchmoney.dev/#recurring-expenses) come through here.
    # @example [Get Recurring Expenses](https://lunchmoney.dev/#get-recurring-expenses)
    #   api = LunchMoney::Api.new
    #   api.recurring_expenses
    sig { returns(LunchMoney::Calls::Base) }
    def recurring_expense_calls
      with_valid_api_key do
        @recurring_expense_calls ||= T.let(
          LunchMoney::Calls::RecurringExpenses.new(api_key:),
          T.nilable(LunchMoney::Calls::RecurringExpenses),
        )
      end
    end

    delegate :budgets, :upsert_budget, :remove_budget, to: :budget_calls

    # All [budget call types](https://lunchmoney.dev/#budget) come through here.
    # @example [Get Budget Summary](https://lunchmoney.dev/#get-budget-summary)
    #   api = LunchMoney::Api.new
    #   api.budgets(start_date: "2023-01-01", end_date: "2024-01-01")
    # @example [Upsert Budget](https://lunchmoney.dev/#upsert-budget)
    #   api = LunchMoney::Api.new
    #   api.upsert_budget(start_date: "2023-01-01", category_id: 777052, amount: 400.99)
    # @example [Remove Budget(https://lunchmoney.dev/#remove-budget)
    #   api = LunchMoney::Api.new
    #   api.remove_budget(start_date: "2023-01-01", category_id: 777052)
    sig { returns(LunchMoney::Calls::Base) }
    def budget_calls
      with_valid_api_key do
        @budget_calls ||= T.let(LunchMoney::Calls::Budgets.new(api_key:), T.nilable(LunchMoney::Calls::Budgets))
      end
    end

    delegate :assets, :create_asset, :update_asset, to: :asset_calls

    # All [assets call types](https://lunchmoney.dev/#assets) come through here.
    # @example [Get All Assets](https://lunchmoney.dev/#get-all-assets)
    #   api = LunchMoney::Api.new
    #   api.assets
    # @example [Create Asset](https://lunchmoney.dev/#create-asset)
    #   api = LunchMoney::Api.new
    #   api.create_asset(
    #     type_name: "cash",
    #     name: "Create Asset Test",
    #     balance: "10.00",
    #   )
    # @example [Update Asset](https://lunchmoney.dev/#update-asset)
    #   api = LunchMoney::Api.new
    #   api.update_asset(93746, balance: "99.99")
    sig { returns(LunchMoney::Calls::Base) }
    def asset_calls
      with_valid_api_key do
        @asset_calls ||= T.let(LunchMoney::Calls::Assets.new(api_key:), T.nilable(LunchMoney::Calls::Assets))
      end
    end

    delegate :plaid_accounts, :plaid_accounts_fetch, to: :plaid_account_calls

    # All [Plaid accounts call types](https://lunchmoney.dev/#plaid-accounts) come through here.
    # @example [Get All Plaid Accounts](https://lunchmoney.dev/#get-all-plaid-accounts)
    #   api = LunchMoney::Api.new
    #   api.plaid_accounts
    # @example [Trigger Fetch from Plaid](https://lunchmoney.dev/#trigger-fetch-from-plaid)
    #   api = LunchMoney::Api.new
    #   api.plaid_accounts_fetch
    sig { returns(LunchMoney::Calls::Base) }
    def plaid_account_calls
      with_valid_api_key do
        @plaid_account_calls ||= T.let(
          LunchMoney::Calls::PlaidAccounts.new(api_key:),
          T.nilable(LunchMoney::Calls::PlaidAccounts),
        )
      end
    end

    delegate :crypto, :update_crypto, to: :crypto_calls

    # All [crypto call types](https://lunchmoney.dev/#crypto) come through here.
    # @example [Get All Crypto](https://lunchmoney.dev/#get-all-crypto)
    #   api = LunchMoney::Api.new
    #   api.crypto
    # @example [Update Manual Crypto Asset](https://lunchmoney.dev/#update-manual-crypto-asset)
    #   api = LunchMoney::Api.new
    #   api.update_crypto(1234567, name: "New Crypto Name")
    sig { returns(LunchMoney::Calls::Base) }
    def crypto_calls
      with_valid_api_key do
        @crypto_calls ||= T.let(LunchMoney::Calls::Crypto.new(api_key:), T.nilable(LunchMoney::Calls::Crypto))
      end
    end

    private

    sig { params(block: T.proc.returns(LunchMoney::Calls::Base)).returns(LunchMoney::Calls::Base) }
    def with_valid_api_key(&block)
      raise(InvalidApiKey, "API key is missing or invalid") if api_key.blank?

      yield
    end
  end
end
