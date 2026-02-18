# frozen_string_literal: true

require_relative "../errors"
require_relative "rate_limit"

module LunchMoney
  module Client
    class Base
      attr_reader :rate_limit

      def initialize(api_key: nil)
        @api_key = api_key || LunchMoney.configuration.api_key
        @connection = build_connection
        @upload_connection = build_upload_connection
        @rate_limit = nil
      end

      private

      def get(endpoint, params: nil)
        handle_response(@connection.get(url(endpoint), params))
      end

      def post(endpoint, body: nil)
        handle_response(@connection.post(url(endpoint), body))
      end

      def put(endpoint, body: nil)
        handle_response(@connection.put(url(endpoint), body))
      end

      def delete(endpoint, params: nil)
        response = @connection.delete(url(endpoint), params)
        update_rate_limit(response)
        return nil if response.status == 204
        handle_response(response)
      end

      def upload(endpoint, file:, content_type: "application/octet-stream", **params)
        payload = { file: Faraday::Multipart::FilePart.new(file, content_type) }
        payload.merge!(params)
        handle_response(@upload_connection.post(url(endpoint), payload))
      end

      def handle_response(response)
        update_rate_limit(response)

        case response.status
        when 200, 201
          response.body
        when 204
          nil
        when 400, 422
          raise_error(ValidationError, response)
        when 401
          raise_error(AuthenticationError, response)
        when 404
          raise_error(NotFoundError, response)
        when 429
          retry_after = response.headers["Retry-After"]&.to_i
          raise RateLimitError.new(
            status_code: response.status,
            message: error_message(response),
            errors: error_details(response),
            retry_after: retry_after,
            response: response,
            rate_limit: @rate_limit
          )
        when 500..599
          raise_error(ServerError, response)
        end
      end

      def raise_error(klass, response)
        raise klass.new(
          status_code: response.status,
          message: error_message(response),
          errors: error_details(response),
          response: response,
          rate_limit: @rate_limit
        )
      end

      def error_message(response)
        response.body.is_a?(Hash) ? response.body[:message] : response.body.to_s
      end

      def error_details(response)
        response.body.is_a?(Hash) ? (response.body[:errors] || []) : []
      end

      def update_rate_limit(response)
        @rate_limit = RateLimit.from_headers(response.headers)
      end

      def url(endpoint)
        "#{base_url}#{endpoint}"
      end

      def base_url
        LunchMoney.configuration.base_url
      end

      def max_retries
        LunchMoney.configuration.max_retries
      end

      def build_connection
        Faraday.new do |conn|
          conn.request(:authorization, "Bearer", @api_key)
          conn.request(:json)
          conn.request(:retry, max: max_retries, retry_statuses: [429])
          conn.response(:json, parser_options: { symbolize_names: true })
        end
      end

      def build_upload_connection
        Faraday.new do |conn|
          conn.request(:authorization, "Bearer", @api_key)
          conn.request(:multipart)
          conn.response(:json, parser_options: { symbolize_names: true })
        end
      end
    end
  end
end
