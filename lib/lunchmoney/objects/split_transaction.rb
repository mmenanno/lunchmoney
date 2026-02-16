# frozen_string_literal: true

# AUTO-GENERATED from LunchMoney OpenAPI spec v2.8.5
# Do not edit manually. Run `toys generate models` to regenerate.

module LunchMoney
  module Objects
    class SplitTransaction < Base
      attr_accessor :amount, :payee, :date, :category_id, :notes

      def validate!
        raise ArgumentError, "amount is required" if amount.nil?
        raise ArgumentError, "payee must be at most 140 characters" if payee && payee.to_s.length > 140
        raise ArgumentError, "notes must be at most 350 characters" if notes && notes.to_s.length > 350
      end
    end
  end
end
