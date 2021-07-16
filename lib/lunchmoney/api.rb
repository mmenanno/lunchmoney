# typed: strict
# frozen_string_literal: true

require "pry"
require "faraday"
require "faraday_middleware"
require_relative "errors"
require_relative "config"
require_relative "objects/split"
require_relative "objects/transaction"
require_relative "objects/tag"
require_relative "objects/category"
require_relative "objects/recurring_expense"
require_relative "objects/data"
require_relative "objects/budget"
require_relative "objects/asset"
require_relative "objects/plaid_account"
require_relative "objects/crypto"

module LunchMoney
  class Api
    extend T::Sig
    BASE_URL = "https://dev.lunchmoney.app/v1/"
    LUNCHMONEY_TOKEN = T.let(LunchMoney.config.token, T.nilable(String))

    sig { returns(T::Array[T.any(T::Hash[Symbol, T.untyped], LunchMoney::Category)]) }
    def get_all_categories
      response = get("categories")

      get_errors(response)

      return response.body[:categories] unless use_structs?
      response.body[:categories].map { |category| LunchMoney::Category.new(category) }
    end

    sig do
      params(name: String, description: T.nilable(String), is_income: T::Boolean, exclude_from_budget: T::Boolean,
        exclude_from_totals: T::Boolean).returns(T.untyped)
    end
    def create_category(name:, description: nil, is_income: false,
      exclude_from_budget: false, exclude_from_totals: false)
      params = {
        name: name,
        description: description,
        is_income: is_income,
        exclude_from_budget: exclude_from_budget,
        exclude_from_totals: exclude_from_totals,
      }

      response = post("categories", params)
      get_errors(response)

      response.body
    end

    sig { returns(T::Array[T.any(T::Hash[Symbol, T.untyped], LunchMoney::Tag)]) }
    def get_all_tags
      response = get("tags")

      get_errors(response)

      return response.body unless use_structs?
      response.body.map { |tag| LunchMoney::Tag.new(tag) }
    end

    sig do
      params(
        tag_id: T.nilable(Integer),
        recurring_id: T.nilable(Integer),
        plaid_account_id: T.nilable(Integer),
        category_id: T.nilable(Integer),
        asset_id: T.nilable(Integer),
        group_id: T.nilable(Integer),
        is_group: T.nilable(T::Boolean),
        status: T.nilable(String),
        offset: T.nilable(Integer),
        limit: T.nilable(Integer),
        start_date: T.nilable(String),
        end_date: T.nilable(String),
        debit_as_negative: T.nilable(T::Boolean)
      ).returns(T.untyped)
    end
    def get_transactions(
      tag_id: nil,
      recurring_id: nil,
      plaid_account_id: nil,
      category_id: nil,
      asset_id: nil,
      group_id: nil,
      is_group: nil,
      status: nil,
      offset: nil,
      limit: nil,
      start_date: nil,
      end_date: nil,
      debit_as_negative: nil
    )

      params = {}
      params[:tag_id] = tag_id if tag_id
      params[:recurring_id] = recurring_id if recurring_id
      params[:plaid_account_id] = plaid_account_id if plaid_account_id
      params[:category_id] = category_id if category_id
      params[:asset_id] = asset_id if asset_id
      params[:group_id] = group_id if group_id
      params[:is_group] = is_group if is_group
      params[:status] = status if status
      params[:offset] = offset if offset
      params[:limit] = limit if limit
      params[:start_date] = start_date if start_date
      params[:end_date] = end_date if end_date
      params[:debit_as_negative] = debit_as_negative if debit_as_negative

      response = if params.empty?
        get("transactions")
      else
        get("transactions", query_params: params)
      end

      get_errors(response)

      return response.body[:transactions] unless use_structs?
      response.body[:transactions].map { |transaction| LunchMoney::Transaction.new(transaction) }
    end

    sig { params(transaction_id: Integer, debit_as_negative: T.nilable(T::Boolean)).returns(T.untyped) }
    def get_single_transaction(transaction_id:, debit_as_negative: nil)
      params = {}
      params[:debit_as_negative] = debit_as_negative if debit_as_negative

      response = if params.empty?
        get("transactions/#{transaction_id}")
      else
        get("transactions/#{transaction_id}", query_params: params)
      end

      get_errors(response)

      return response.body unless use_structs?
      LunchMoney::Transaction.new(response.body)
    end

    sig do
      params(transactions: T::Array[LunchMoney::Transaction],
        apply_rules: T.nilable(T::Boolean),
        skip_duplicates: T.nilable(T::Boolean),
        check_for_recurring: T.nilable(T::Boolean),
        debit_as_negative: T.nilable(T::Boolean),
        skip_balance_update: T.nilable(T::Boolean)).returns(T.untyped)
    end
    def insert_transactions(transactions, apply_rules: nil, skip_duplicates: nil,
      check_for_recurring: nil, debit_as_negative: nil, skip_balance_update: nil)
      params = { transactions: transactions.map(&:serialize) }
      params[:apply_rules] = apply_rules if apply_rules
      params[:skip_duplicates] = skip_duplicates if skip_duplicates
      params[:check_for_recurring] = check_for_recurring if check_for_recurring
      params[:debit_as_negative] = debit_as_negative if debit_as_negative
      params[:skip_balance_update] = skip_balance_update if skip_balance_update

      response = post("transactions", params)
      get_errors(response)

      response.body
    end

    sig do
      params(
        transaction_id: Integer,
        transaction: LunchMoney::Transaction,
        split: T.nilable(LunchMoney::Split),
        debit_as_negative: T::Boolean,
        skip_balance_update: T::Boolean
      ).returns(T.untyped)
    end
    def update_transaction(transaction_id, transaction:, split: nil,
      debit_as_negative: false, skip_balance_update: true)
      body = transaction.wrap_and_serialize
      body.merge!(split) if split
      body["debit_as_negative"] = debit_as_negative if debit_as_negative
      body["skip_balance_update"] = skip_balance_update unless skip_balance_update

      response = put("transactions/#{transaction_id}", body)
      get_errors(response)
      response.body
    end

    sig do
      params(
        date: String,
        payee: String,
        transactions: T::Array[T.any(Integer, String)],
        category_id: T.nilable(Integer),
        notes: T.nilable(String),
        tags: T.nilable(T::Array[T.any(Integer, String)])
      ).returns(T.untyped)
    end
    def create_transaction_group(date:, payee:, transactions:, category_id: nil, notes: nil, tags: nil)
      params = {
        date: date,
        payee: payee,
        transactions: transactions,
      }
      params[:category_id] = category_id if category_id
      params[:notes] = notes if notes
      params[:tags] = tags if tags

      response = post("transactions/group", params)
      get_errors(response)

      response.body
    end

    sig { params(transaction_id: T.any(String, Integer)).returns(T.untyped) }
    def delete_transaction_group(transaction_id)
      response = delete("transactions/group/#{transaction_id}")
      get_errors(response)

      response.body
    end

    sig do
      params(start_date: T.nilable(String),
        debit_as_negative: T.nilable(T::Boolean)).returns(T::Array[T.any(T::Hash[Symbol, T.untyped],
          LunchMoney::RecurringExpense)])
    end
    def get_recurring_expenses(start_date: nil, debit_as_negative: nil)
      params = {}
      params[:start_date] = start_date if start_date
      params[:debit_as_negative] = debit_as_negative if debit_as_negative

      response = if params.empty?
        get("recurring_expenses")
      else
        get("recurring_expenses", query_params: params)
      end

      get_errors(response)

      return response.body[:recurring_expenses] unless use_structs?
      response.body[:recurring_expenses].map { |recurring_expense| LunchMoney::RecurringExpense.new(recurring_expense) }
    end

    sig { params(start_date: String, end_date: String).returns(T.untyped) }
    def get_budget_summary(start_date:, end_date:)
      params = {
        start_date: start_date,
        end_date: end_date,
      }
      response = get("budgets", query_params: params)
      get_errors(response)

      response.body

      # TODO: below code is for use_structs path, however with changes to the
      # endpoint I do not have the documenation yet to finish that version
      response.body.map do |budget|
        budget[:data].each do |key, value|
          budget[:data][key] = LunchMoney::Data.new(value)
        end

        LunchMoney::Budget.new(budget)
      end
    end

    sig { params(body: T.untyped).returns(T.untyped) }
    def upsert_budget(body)
      # TODO
      # response = put("budgets", body)
      # get_errors(response)
      # response.body
    end

    sig { returns(T.untyped) }
    def remove_budget
      # TODO
      # response = delete("budgets")
      # response.body
    end

    sig { returns(T.untyped) }
    def get_all_assets
      response = get("assets")

      get_errors(response)

      return response.body[:assets] unless use_structs?
      response.body[:assets].map { |asset| LunchMoney::Asset.new(asset) }
    end

    sig do
      params(
        asset_id: T.any(Integer, String),
        type_name: T.nilable(String),
        subtype_name: T.nilable(String),
        name: T.nilable(String),
        balance: T.nilable(String),
        balance_as_of: T.nilable(String),
        currency: T.nilable(String),
        institution_name: T.nilable(String),
      ).returns(T.untyped)
    end
    def update_asset(asset_id, type_name: nil, subtype_name: nil, name: nil, balance: nil,
      balance_as_of: nil, currency: nil, institution_name: nil)
      params = {}
      params[:type_name] = type_name if type_name
      params[:subtype_name] = subtype_name if subtype_name
      params[:name] = name if name
      params[:balance] = balance if balance
      params[:balance_as_of] = balance_as_of if balance_as_of
      params[:currency] = currency if currency
      params[:institution_name] = institution_name if institution_name

      response = put("assets/#{asset_id}", params)

      get_errors(response)

      return response.body unless use_structs?
      LunchMoney::Asset.new(response.body)
    end

    sig { returns(T.untyped) }
    def get_all_plaid_accounts
      response = get("plaid_accounts")

      get_errors(response)

      return response.body[:plaid_accounts] unless use_structs?
      response.body[:plaid_accounts].map { |plaid_account| LunchMoney::PlaidAccount.new(plaid_account) }
    end

    sig { returns(T.untyped) }
    def get_all_crypto
      response = get("crypto")

      get_errors(response)

      return response.body[:crypto] unless use_structs?
      response.body[:crypto].map { |crypto| LunchMoney::Crypto.new(crypto) }
    end

    sig do
      params(
        crypto_asset_id: T.any(Integer, String),
        name: T.nilable(String),
        display_name: T.nilable(String),
        institution_name: T.nilable(String),
        balance: T.nilable(T.any(Integer, String)),
        currency: T.nilable(String)
      ).returns(T.untyped)
    end
    def update_manual_crypto(crypto_asset_id, name: nil, display_name: nil,
      institution_name: nil, balance: nil, currency: nil)
      params = {}
      params[:name] = name if name
      params[:display_name] = display_name if display_name
      params[:institution_name] = institution_name if institution_name
      params[:balance] = balance if balance
      params[:currency] = currency if currency

      response = put("crypto/manual/#{crypto_asset_id}", params)

      get_errors(response)

      return response.body unless use_structs?
      LunchMoney::Asset.new(response.body)
    end

    private

    sig { params(endpoint: String, query_params: T.nilable(T::Hash[String, T.untyped])).returns(Faraday::Response) }
    def get(endpoint, query_params: nil)
      request = Faraday.new do |conn|
        conn.authorization(:Bearer, LUNCHMONEY_TOKEN)
        conn.options.params_encoder = Faraday::FlatParamsEncoder
        conn.response(:json, content_type: /json$/, parser_options: { symbolize_names: true })
      end

      if query_params
        request.get(BASE_URL + endpoint, query_params)
      else
        request.get(BASE_URL + endpoint)
      end
    end

    sig { params(endpoint: String, params: T.nilable(T::Hash[String, T.untyped])).returns(Faraday::Response) }
    def post(endpoint, params)
      request = Faraday.new do |conn|
        conn.authorization(:Bearer, LUNCHMONEY_TOKEN)
        conn.request(:json)
        conn.response(:json, content_type: /json$/, parser_options: { symbolize_names: true })
      end

      request.post(BASE_URL + endpoint, params)
    end

    sig { params(endpoint: String, body: T::Hash[String, T.untyped]).returns(Faraday::Response) }
    def put(endpoint, body)
      request = Faraday.new do |conn|
        conn.authorization(:Bearer, LUNCHMONEY_TOKEN)
        conn.request(:json)
        conn.response(:json, content_type: /json$/, parser_options: { symbolize_names: true })
      end

      request.put(BASE_URL + endpoint) do |req|
        req.body = body
      end
    end

    sig { params(endpoint: String).returns(Faraday::Response) }
    def delete(endpoint)
      request = Faraday.new do |conn|
        conn.authorization(:Bearer, LUNCHMONEY_TOKEN)
        conn.response(:json, content_type: /json$/, parser_options: { symbolize_names: true })
      end

      request.delete(BASE_URL + endpoint)
    end

    sig { params(response: T.untyped).void }
    def get_errors(response)
      body = response.body
      if body.is_a?(Hash)
        parse_and_raise_error(body) if body[:error]
        raise(LunchMoney::ValidateError, body[:message]) if body[:name]&.eql?("ValidateError")
      end
    end

    sig { params(body: T.untyped).void }
    def parse_and_raise_error(body)
      error = body[:error]
      raise(LunchMoney::MultipleIssuesError, error) if error.is_a?(Array)

      case error
      when /Missing category name|Category \w+ must be less than /
        raise(LunchMoney::CategoryError, error)
      when /Operation error occurred/
        raise(LunchMoney::OperationError, error)
      when /Both start_date and end_date must be specified./
        raise(LunchMoney::MissingDateError, error)
      when /Transaction ID not found/
        raise(LunchMoney::UnknownTransactionError, error)
      when /Must be in format YYYY-MM-DD/
        raise(LunchMoney::InvalidDateError, error)
      when /Budget must be greater than or equal/
        raise(LunchMoney::BudgetAmountError, error)
      else
        raise(LunchMoney::GeneralError, error)
      end
    end

    sig { returns(T::Boolean) }
    def use_structs?
      LunchMoney.config.response_objects_as_structs
    end
  end
end
