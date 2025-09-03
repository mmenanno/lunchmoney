# typed: strict
# frozen_string_literal: true

module LunchMoney
  # Namespace for data objects that represent objects returned from the API
  module Objects
    # Base data object for the objects returned and used when calling the LunchMoney API
    class Object
      sig { params(symbolize_keys: T::Boolean).returns(T::Hash[T.any(String, Symbol), T.untyped]) }
      def serialize(symbolize_keys: false)
        output = {}

        instance_variables.each do |ivar|
          key_string = ivar.to_s.delete_prefix("@")
          key = symbolize_keys ? key_string.to_sym : key_string
          output[key] = instance_variable_get(ivar)
        end

        output
      end

      delegate :to_h, to: :serialize
    end
  end
end
