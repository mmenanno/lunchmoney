# typed: strict
# frozen_string_literal: true

module LunchMoney
  class DataObject
    sig { params(symbolize_keys: T::Boolean).returns(T::Hash[String, T.untyped]) }
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
  end
end
