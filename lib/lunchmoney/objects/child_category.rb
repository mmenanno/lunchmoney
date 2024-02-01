# typed: strict
# frozen_string_literal: true

module LunchMoney
  module Objects
    # A slimmed down version of https://lunchmoney.dev/#categories-object used in the
    # `children` field of some category calls
    class ChildCategory < LunchMoney::Objects::Object
      sig { returns(Integer) }
      attr_accessor :id

      sig { returns(String) }
      attr_accessor :name

      sig { returns(T.nilable(String)) }
      attr_accessor :description, :archived_on, :updated_at, :created_at

      sig { returns(T.nilable(T::Boolean)) }
      attr_accessor :archived

      sig do
        params(
          id: Integer,
          name: String,
          archived: T.nilable(T::Boolean),
          archived_on: T.nilable(String),
          updated_at: T.nilable(String),
          created_at: T.nilable(String),
          description: T.nilable(String),
        ).void
      end
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
