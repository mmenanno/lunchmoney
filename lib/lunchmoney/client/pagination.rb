# frozen_string_literal: true

module LunchMoney
  module Client
    class Pagination
      include Enumerable

      def initialize(client:, params:)
        @client = client
        @params = params
      end

      def each(&block)
        offset = @params.fetch(:offset, 0)
        limit = @params.fetch(:limit, 1000)

        loop do
          page = @client.transactions_page(**@params, offset: offset, limit: limit)
          page[:transactions].each(&block)
          break unless page[:has_more]

          offset += limit
        end
      end
    end
  end
end
