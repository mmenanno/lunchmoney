# frozen_string_literal: true

module LunchMoney
  class Config
    attr_accessor :token

    def token
      @token || ENV.fetch('LUNCHMONEY_TOKEN')
    end
  end

  def self.configure(&block)
    block.call(config)
  end

  def self.config
    @configuration ||= Config.new
  end
end
