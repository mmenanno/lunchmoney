# typed: strict
# frozen_string_literal: true

module LunchMoney
  # Namespace for data objects that represent objects returned from the API
  module Objects
    # Base data object for the objects returned and used when calling the LunchMoney API
    class Object
      sig { params(symbolize_keys: T::Boolean).returns(T::Hash[T.any(String, Symbol), T.untyped]) }
      def serialize(symbolize_keys: false)
        ivars = instance_variables

        output = {}

        ivars.each do |ivar|
          key = ivar.to_s.gsub("@", "")
          key = key.to_sym if symbolize_keys

          value = instance_variable_get(ivar)

          output[key] = value
        end

        output
      end

      delegate :to_h, to: :serialize
    end
  end
end
