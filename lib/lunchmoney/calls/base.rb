# typed: strict
# frozen_string_literal: true

require_relative "../errors"

module LunchMoney
  # Namespace for all API call classes. The methods on these classes should not typically be accessed directly.
  # Instead they should be accessed through `LunchMoney::Api` instances, which will handle delegating the methods to
  # the appropriate Calls class.
  # @example
  #   api = LunchMoney::Api.new
  #   api.categories # This will be delegated to LunchMoney::Calls::Categories#categories
  module Calls
    # Base class for all API call types. Containing the base methods got HTTP call types like GET / POST / PUT / DELETE
    # as well as the general error handler
    class Base
      # Base URL used for API calls
      BASE_URL = "https://dev.lunchmoney.app/v1/"

      sig { returns(T.nilable(String)) }
      attr_reader :api_key

      sig { params(api_key: T.nilable(String)).void }
      def initialize(api_key: nil)
        @api_key = T.let(api_key || LunchMoney.configuration.api_key, T.nilable(String))
        @connections = T.let({}, T::Hash[Symbol, Faraday::Connection])
      end

      private

      sig { params(endpoint: String, query_params: T.nilable(T::Hash[Symbol, T.untyped])).returns(Faraday::Response) }
      def get(endpoint, query_params: nil)
        connection = connection_for(:flat_params)

        if query_params.present?
          connection.get(BASE_URL + endpoint, query_params)
        else
          connection.get(BASE_URL + endpoint)
        end
      end

      sig { params(endpoint: String, params: T.nilable(T::Hash[Symbol, T.untyped])).returns(Faraday::Response) }
      def post(endpoint, params)
        connection_for(:json).post(BASE_URL + endpoint, params)
      end

      sig { params(endpoint: String, body: T::Hash[Symbol, T.untyped]).returns(Faraday::Response) }
      def put(endpoint, body)
        connection_for(:json).put(BASE_URL + endpoint) do |req|
          req.body = body
        end
      end

      sig { params(endpoint: String, query_params: T.nilable(T::Hash[Symbol, T.untyped])).returns(Faraday::Response) }
      def delete(endpoint, query_params: nil)
        connection = connection_for(:flat_params)

        if query_params.present?
          connection.delete(BASE_URL + endpoint, query_params)
        else
          connection.delete(BASE_URL + endpoint)
        end
      end

      sig { params(connection_type: Symbol).returns(Faraday::Connection) }
      def connection_for(connection_type)
        @connections[connection_type] ||= case connection_type
        when :json
          build_connection(json_request: true)
        when :flat_params
          build_connection(flat_params: true)
        else
          build_connection
        end
      end

      sig { params(json_request: T::Boolean, flat_params: T::Boolean).returns(Faraday::Connection) }
      def build_connection(json_request: false, flat_params: false)
        Faraday.new do |conn|
          conn.request(:authorization, "Bearer", @api_key)
          conn.request(:json) if json_request
          conn.options.params_encoder = Faraday::FlatParamsEncoder if flat_params
          conn.response(:json, content_type: /json$/, parser_options: { symbolize_names: true })
        end
      end

      sig { params(response: Faraday::Response).returns(LunchMoney::Errors) }
      def errors(response)
        body = response.body

        return parse_errors(body) unless error_hash(body).nil?

        LunchMoney::Errors.new
      end

      sig { params(body: T::Hash[Symbol, T.any(String, T::Array[String])]).returns(LunchMoney::Errors) }
      def parse_errors(body)
        errors = error_hash(body)
        api_errors = LunchMoney::Errors.new
        return api_errors if errors.blank?

        case errors
        when String
          api_errors << errors
        when Array
          errors.each { |error| api_errors << error }
        end

        api_errors
      end

      sig { params(body: T.untyped).returns(T.untyped) }
      def error_hash(body)
        return unless body.is_a?(Hash)

        if body[:error]
          body[:error]
        elsif body[:errors]
          body[:errors]
        elsif body[:name] == "Error"
          body[:message]
        end
      end

      sig { params(params: T::Hash[Symbol, T.untyped]).returns(T::Hash[Symbol, T.untyped]) }
      def clean_params(params)
        params.reject! { |_key, value| value.nil? }
      end

      sig do
        type_parameters(:T)
          .params(
            response: Faraday::Response,
            block: T.proc.params(body: T.untyped).returns(T.type_parameter(:T)),
          )
          .returns(T.any(T.type_parameter(:T), LunchMoney::Errors))
      end
      def handle_api_response(response, &block)
        api_errors = errors(response)
        return api_errors if api_errors.present?

        yield(response.body)
      end
    end
  end
end
