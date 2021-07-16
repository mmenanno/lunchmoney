# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

module LunchMoney
  extend T::Sig
  class Config
    extend T::Sig

    sig { returns(T.nilable(String)) }
    attr_accessor :token

    sig { returns(T::Boolean) }
    attr_accessor :response_objects_as_structs

    sig { void }
    def initialize
      @response_objects_as_structs = T.let(false, T::Boolean)
    end

    sig { returns(T.nilable(String)) }
    def token
      T.let(@token, T.nilable(String)) || ENV.fetch("LUNCHMONEY_TOKEN", nil)
    end
  end

  sig { T.proc.params(block: T.untyped).returns(T.untyped) }
  def self.configure(&block)
    block.call(config)
  end

  sig { returns(Config) }
  def self.config
    @configuration = T.let(nil, T.nilable(Config)) unless @configuration
    @configuration ||= Config.new
  end
end
