# frozen_string_literal: true

module LunchMoney
  class Error < StandardError; end

  class ApiError < Error
    attr_reader :status_code, :message, :errors, :response, :rate_limit

    def initialize(status_code:, message:, errors: [], response: nil, rate_limit: nil)
      @status_code = status_code
      @message = message
      @errors = errors
      @response = response
      @rate_limit = rate_limit
      super(message)
    end
  end

  class AuthenticationError < ApiError; end
  class NotFoundError < ApiError; end
  class ValidationError < ApiError; end

  class RateLimitError < ApiError
    attr_reader :retry_after

    def initialize(retry_after: nil, **kwargs)
      @retry_after = retry_after
      super(**kwargs)
    end
  end

  class ServerError < ApiError; end

  class ConfigurationError < Error; end
  class InvalidApiKey < ConfigurationError; end
end
