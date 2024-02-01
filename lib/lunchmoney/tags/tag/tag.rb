# typed: strict
# frozen_string_literal: true

require_relative "tag_base"

module LunchMoney
  # https://lunchmoney.dev/#tags-object
  class Tag < TagBase
    sig { returns(T.nilable(String)) }
    attr_accessor :description

    sig { returns(T::Boolean) }
    attr_accessor :archived

    sig { params(id: Integer, name: String, archived: T::Boolean, description: T.nilable(String)).void }
    def initialize(id:, name:, archived:, description: nil)
      super(id:, name:)
      @archived = archived
      @description = description
    end
  end
end
