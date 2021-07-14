# frozen_string_literal: true

require "pry"
require "faraday"
require "faraday_middleware"
require_relative "errors"
require_relative "config"

module LunchMoney
  class Api
    BASE_URL = "https://dev.lunchmoney.app/v1/"
    LUNCHMONEY_TOKEN = LunchMoney.config.token

    def get_all_categories
      response = get("categories")
      get_errors(response)
      response.body[:categories]
    end

    def create_category(name:, description: nil, is_income: false, exclude_from_budget: false, exclude_from_totals: false)
      params = {
        name: name,
        description: description,
        is_income: is_income,
        exclude_from_budget: exclude_from_budget,
        exclude_from_totals: exclude_from_totals
      }

      response = post("categories", params)
      get_errors(response)

      if response.status
        response.body
      end
    end

    def get_all_tags
      response = get("tags")
      get_errors(response)
      response.body
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
      debit_as_negative: nil)

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

      if params.empty?
        response = get("transactions")
      else
        response = get("transactions", query_params: params)
      end

      get_errors(response)
      response.body[:transactions]
    end

    def get_single_transaction(transaction_id:, debit_as_negative: nil)
      params = {}
      params[:debit_as_negative] = debit_as_negative if debit_as_negative

      if params.empty?
        response = get("transactions/#{transaction_id}")
      else
        response = get("transactions/#{transaction_id}", query_params: params)
      end

      get_errors(response)
      response.body[:transactions]
    end

    def update_transaction(transaction_id, body)
      response = put("transaction/#{transaction_id}", body)
      get_errors(response)
      response.body
    end

    private

    def get(endpoint, query_params: nil)
      request = Faraday.new do |conn|
        conn.authorization(:Bearer, LUNCHMONEY_TOKEN)
        conn.options.params_encoder = Faraday::FlatParamsEncoder
        conn.response(:json, content_type: /json$/, :parser_options => { :symbolize_names => true })
      end

      if query_params
        request.get(BASE_URL + endpoint, query_params)
      else
        request.get(BASE_URL + endpoint)
      end
    end

    def post(endpoint, params)
      request = Faraday.new do |conn|
        conn.authorization(:Bearer, LUNCHMONEY_TOKEN)
        conn.request(:json)
        conn.response(:json, content_type: /json$/, :parser_options => { :symbolize_names => true })
      end

      request.post(BASE_URL + endpoint, params)
    end

    def put(endpoint, body)
      request = Faraday.new do |conn|
        conn.authorization(:Bearer, LUNCHMONEY_TOKEN)
        conn.request(:json)
        conn.response(:json, content_type: /json$/, :parser_options => { :symbolize_names => true })
      end

      request.put(BASE_URL + endpoint) do |req|
        req.body = { "transaction": body }
      end
    end

    def get_errors(response)
      body = response.body
      if response.status == 200
        raise(LunchMoney::GeneralError, body[:error]) if body.class == Hash && body[:error]
      else
        body = response.body

        error_class = Object.const_get("LunchMoneyError::#{body[:name]}")
        raise(error_class, body[:message])
      end
    rescue NameError
      if body.is_a?(Hash) && body[:error]
        raise(LunchMoney::GeneralError, body[:error])
      elsif body[:name] || body[:message]
        raise(LunchMoney::UnRecognizedError, "#{body[:name]}: #{body[:message]}")
      else
        raise(LunchMoney::UnRecognizedError, body)
      end
    end
  end
end
