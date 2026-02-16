# frozen_string_literal: true

module Mocha
  # Extension for Mocha Mocks to provide instance_double and double helpers.
  module Typed
    # Instance doubles may only define methods that the caller responds to.
    def instance_double(type)
      mock = typed_mock(type)

      if type.is_a?(Class)
        mock.responds_like(type.allocate)
      elsif type.is_a?(Module)
        mock.responds_like(Class.new.include(type).allocate)
      end

      mock
    end

    def double(type)
      m = typed_mock(type)
      m.responds_like(type)
      m
    end

    # A mock that will satisfy is_a? checks for the given type.
    def typed_mock(type)
      m = mock(type.to_s)
      m.define_singleton_method(:is_a?) { |k| type <= k }
      m
    end
  end
end
