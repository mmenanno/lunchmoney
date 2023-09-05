# typed: strict
# frozen_string_literal: true

module LunchMoney
  class BaseApiCall
    BASE_URL = "https://dev.lunchmoney.app/v1/"
    LUNCHMONEY_TOKEN = T.let(LunchMoney::Config.token, T.nilable(String))

    sig { returns(T.nilable(String)) }
    attr_accessor :api_key

    sig { params(api_key: T.nilable(String)).void }
    def initialize(api_key: nil)
      @api_key = T.let(api_key || LunchMoney::Config.token, T.nilable(String))
    end

    private

    sig { params(endpoint: String, query_params: T.nilable(T::Hash[String, T.untyped])).returns(Faraday::Response) }
    def get(endpoint, query_params: nil)
      connection = request(flat_params: true)

      if query_params
        connection.get(BASE_URL + endpoint, query_params)
      else
        connection.get(BASE_URL + endpoint)
      end
    end

    sig { params(endpoint: String, params: T.nilable(T::Hash[String, T.untyped])).returns(Faraday::Response) }
    def post(endpoint, params)
      request(json_request: true).post(BASE_URL + endpoint, params)
    end

    sig { params(endpoint: String, body: T::Hash[String, T.untyped]).returns(Faraday::Response) }
    def put(endpoint, body)
      request(json_request: true).put(BASE_URL + endpoint) do |req|
        req.body = body
      end
    end

    sig { params(endpoint: String).returns(Faraday::Response) }
    def delete(endpoint)
      request.delete(BASE_URL + endpoint)
    end

    sig { params(json_request: T::Boolean, flat_params: T::Boolean).returns(Faraday::Connection) }
    def request(json_request: false, flat_params: false)
      Faraday.new do |conn|
        conn.request(:authorization, "Bearer", @api_key)
        conn.request(:json) if json_request
        # conn.options.params_encoder = Faraday::FlatParamsEncoder if flat_params
        conn.response(:json, content_type: /json$/, parser_options: { symbolize_names: true })
      end
    end

    sig { params(response: T.untyped).void }
    def errors(response)
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
  end
end
