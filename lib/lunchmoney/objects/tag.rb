# frozen_string_literal: true

require_relative "tag_base"

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#tags-object
    class Tag < TagBase
      attr_accessor :description

      attr_accessor :archived

      def initialize(id:, name:, archived:, description: nil)
        super(id:, name:)
        @archived = archived
        @description = description
      end
    end
  end
end
