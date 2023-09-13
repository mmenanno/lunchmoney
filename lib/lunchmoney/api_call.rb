# typed: strict
# frozen_string_literal: true

module LunchMoney
  class ApiCall
    BASE_URL = "https://dev.lunchmoney.app/v1/"
    LUNCHMONEY_TOKEN = T.let(LunchMoney::Config.token, T.nilable(String))

    sig { returns(T.nilable(String)) }
    attr_reader :api_key

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

    sig { params(response: Faraday::Response).returns(LunchMoney::Errors) }
    def errors(response)
      body = response.body

      return parse_errors(body) if body.is_a?(Hash) && body[:error]

      []
    end

    sig { params(body: T::Hash[Symbol, T.any(String, T::Array[String])]).returns(LunchMoney::Errors) }
    def parse_errors(body)
      errors = body[:error]
      return [] if errors.blank?

      api_errors = []

      if errors.class == String
        api_errors << LunchMoney::Error.new(message: errors)
      elsif errors.class == Array
        T.cast(errors, T::Array[String]).each do |error|
          api_errors << LunchMoney::Error.new(message: error)
        end
      end

      api_errors
    end
  end
end
