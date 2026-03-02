# frozen_string_literal: true

module LunchMoney
  class RateLimit
    attr_reader :limit, :remaining, :reset

    def initialize(limit:, remaining:, reset:)
      @limit = limit
      @remaining = remaining
      @reset = reset
    end

    def self.from_headers(headers)
      return nil unless headers["RateLimit-Limit"]

      new(
        limit: headers["RateLimit-Limit"].to_i,
        remaining: headers["RateLimit-Remaining"].to_i,
        reset: headers["RateLimit-Reset"].to_i
      )
    end

    def exhausted?
      remaining == 0
    end
  end
end
