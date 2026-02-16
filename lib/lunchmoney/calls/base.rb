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

      attr_reader :api_key

      def initialize(api_key: nil)
        @api_key = api_key || LunchMoney.configuration.api_key
        @connections = {}
      end

      private

      def get(endpoint, query_params: nil)
        connection = connection_for(:flat_params)

        if query_params.present?
          connection.get(BASE_URL + endpoint, query_params)
        else
          connection.get(BASE_URL + endpoint)
        end
      end

      def post(endpoint, params)
        connection_for(:json).post(BASE_URL + endpoint, params)
      end

      def put(endpoint, body)
        connection_for(:json).put(BASE_URL + endpoint) do |req|
          req.body = body
        end
      end

      def delete(endpoint, query_params: nil)
        connection = connection_for(:flat_params)

        if query_params.present?
          connection.delete(BASE_URL + endpoint, query_params)
        else
          connection.delete(BASE_URL + endpoint)
        end
      end

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

      def build_connection(json_request: false, flat_params: false)
        Faraday.new do |conn|
          conn.request(:authorization, "Bearer", @api_key)
          conn.request(:json) if json_request
          conn.options.params_encoder = Faraday::FlatParamsEncoder if flat_params
          conn.response(:json, content_type: /json$/, parser_options: { symbolize_names: true })
        end
      end

      def errors(response)
        body = response.body

        return parse_errors(body) unless error_hash(body).nil?

        LunchMoney::Errors.new
      end

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

      def clean_params(params)
        params.reject { |_key, value| value.nil? }
      end

      def handle_api_response(response, &block)
        api_errors = errors(response)
        return api_errors if api_errors.present?

        yield(response.body)
      end

      def handle_collection_response(response, collection_key, lazy: false, &block)
        api_errors = errors(response)
        return api_errors if api_errors.present?

        collection = response.body[collection_key]
        return [] unless collection

        if lazy
          collection.lazy.map(&block)
        else
          collection.map(&block)
        end
      end
    end
  end
end
