# frozen_string_literal: true

module LunchMoney
  module Objects
    # A slimmed down version of https://lunchmoney.dev/#categories-object used in the
    # `children` field of some category calls
    class ChildCategory < LunchMoney::Objects::Object
      attr_accessor :id

      attr_accessor :name

      attr_accessor :description, :archived_on, :updated_at, :created_at

      attr_accessor :archived

      def initialize(id:, name:, archived: nil, archived_on: nil, updated_at: nil, created_at: nil, description: nil)
        super()
        @id = id
        @name = name
        @archived = archived
        @archived_on = archived_on
        @updated_at = updated_at
        @created_at = created_at
        @description = description
      end
    end
  end
end
