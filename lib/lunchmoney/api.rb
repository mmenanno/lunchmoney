# typed: strict
# frozen_string_literal: true

require "pry"
require "faraday"
require "faraday_middleware"
require_relative "errors"
require_relative "config"

module LunchMoney
  class Api
    extend T::Sig
    BASE_URL = "https://dev.lunchmoney.app/v1/"
    LUNCHMONEY_TOKEN = T.let(LunchMoney.config.token, T.nilable(String))

    sig { returns(T.untyped) }
    def get_all_categories
      response = get("categories")
      get_errors(response)
      response.body[:categories]
    end

    sig do
      params(name: String, description: T.nilable(String), is_income: T::Boolean, exclude_from_budget: T::Boolean,
        exclude_from_totals: T::Boolean).returns(T.untyped)
    end
    def create_category(
      name:,
      description: nil,
      is_income: false,
      exclude_from_budget: false,
      exclude_from_totals: false
    )
      params = {
        name: name,
        description: description,
        is_income: is_income,
        exclude_from_budget: exclude_from_budget,
        exclude_from_totals: exclude_from_totals,
      }

      response = post("categories", params)
      get_errors(response)

      if response.status
        response.body
      end
    end

    sig { returns(T.untyped) }
    def get_all_tags
      response = get("tags")
      get_errors(response)
      response.body
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
      response.body[:transactions]
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
      response.body[:transactions]
    end

    sig { params(transaction_id: Integer, body: T.untyped).returns(T.untyped) }
    def update_transaction(transaction_id, body)
      response = put("transaction/#{transaction_id}", body)
      get_errors(response)
      response.body
    end

    sig { returns(T.untyped) }
    def get_budget_summary
      response = get("budgets")
      get_errors(response)
      response.body[:budgets]
    end

    sig { params(body: T.untyped).returns(T.untyped) }
    def upsert_budget(body)
      response = put("budgets", body)
      get_errors(response)
      response.body
    end

    sig { returns(T.untyped) }
    def get_all_assets
      response = get("assets")
      get_errors(response)
      response.body[:assets]
    end

    sig { params(asset_id: Integer, body: T.untyped).returns(T.untyped) }
    def update_asset(asset_id, body)
      response = put("assets/#{asset_id}", body)
      get_errors(response)
      response.body
    end

    sig { returns(T.untyped) }
    def get_all_plaid_accounts
      response = get("plaid_accounts")
      get_errors(response)
      response.body[:plaid_accounts]
    end

    sig { returns(T.untyped) }
    def get_all_crypto
      response = get("crypto")
      get_errors(response)
      response.body[:crypto]
    end

    sig { params(crypto_asset_id: Integer, body: T.untyped).returns(T.untyped) }
    def update_manual_crypto(crypto_asset_id, body)
      response = put("crypto/manual/#{crypto_asset_id}", body)
      get_errors(response)
      response.body
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
        req.body = { "transaction": body }
      end
    end

    sig { params(response: T.untyped).void }
    def get_errors(response)
      body = response.body
      if body.is_a?(Hash)
        parse_and_raise_error(body) if body[:error]
        raise(LunchMoney::ValidateError, body[:message]) if body[:name]&.includes?("ValidateError")
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
  end
end
