# frozen_string_literal: true

module LunchMoney
  module Objects
    class Base
      def initialize(**attributes)
        attributes.each do |key, value|
          instance_variable_set(:"@#{key}", value) if respond_to?(:"#{key}=")
        end
      end

      def serialize
        instance_variables.each_with_object({}) do |ivar, hash|
          key = ivar.to_s.delete_prefix("@")
          next if key.start_with?("_hydrated_")

          hash[key] = instance_variable_get(ivar)
        end
      end

      private

      def hydrate(ivar_name, client:, &fetch_block)
        cached = instance_variable_get(:"@_hydrated_#{ivar_name}")
        return cached if cached

        result = fetch_block.call(client)
        instance_variable_set(:"@_hydrated_#{ivar_name}", result)
        result
      end
    end
  end
end
