# typed: strict
# frozen_string_literal: true

module LunchMoney
  module Calls
    class DeprecateTestCalls
      include LunchMoney::Deprecate

      sig { returns(String) }
      def old_endpoint_no_replacement
        deprecate_endpoint

        "This is the old endpoint"
      end

      sig { returns(String) }
      def old_endpoint_with_replacement
        deprecate_endpoint("#new_endpoint")

        "This is the old endpoint"
      end

      sig { returns(String) }
      def old_endpoint_error_level
        deprecate_endpoint(level: :error)

        "This is the old endpoint with error level"
      end

      sig { returns(String) }
      def old_endpoint_info_level
        deprecate_endpoint(level: :info)

        "This is the old endpoint with info level"
      end
    end
  end
end
