# frozen_string_literal: true

module LunchMoney
  module Calls
    module Base
      private

      def build_object(klass, data)
        return nil if data.nil?

        klass.new(**data)
      end

      def build_collection(klass, data, key: nil)
        items = key ? data&.dig(key) : data
        return [] if items.nil?

        items.map { |item| klass.new(**item) }
      end
    end
  end
end
