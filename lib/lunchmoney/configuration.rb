# frozen_string_literal: true

module LunchMoney
  class Configuration
    attr_accessor :api_key, :base_url, :max_retries

    def initialize
      @api_key = ENV.fetch("LUNCHMONEY_TOKEN", nil)
      @base_url = "https://api.lunchmoney.dev/v2"
      @max_retries = 3
    end
  end
end
