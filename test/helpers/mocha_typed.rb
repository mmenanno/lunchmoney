# typed: strict
# frozen_string_literal: true

module Mocha
  # Extension for Mocha Mocks to make them play well with sorbet.
  module Typed
    include(Kernel)
    extend(T::Helpers)

    requires_ancestor { Mocha::API }

    # Instance doubles may only define methods that the caller responds to.
    sig { params(type: T.any(Module, T::Class[T.anything])).returns(T.untyped) }
    def instance_double(type)
      mock = typed_mock(type)

      if type.is_a?(Class)
        mock.responds_like(type.allocate)
      elsif type.is_a?(Module)
        mock.responds_like(Class.new.include(type).allocate)
      end

      mock
    end

    sig { params(type: T.any(Module, T::Class[T.anything])).returns(T.untyped) }
    def double(type)
      m = typed_mock(type)
      m.responds_like(type)
      m
    end

    # A mock that will satisfy a sorbet verification check.
    sig { params(type: T.any(Module, T::Class[T.anything])).returns(T.untyped) }
    def typed_mock(type)
      m = mock(type.to_s)
      m.define_singleton_method(:is_a?) { |k| type <= k }
      m
    end
  end
end
