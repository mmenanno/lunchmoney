# typed: strict
# frozen_string_literal: true

module LunchMoney
  class Tag < LunchMoney::DataObject
    sig { returns(Integer) }
    attr_accessor :id

    sig { returns(String) }
    attr_accessor :name

    sig { returns(T.nilable(String)) }
    attr_accessor :description

    sig { returns(T::Boolean) }
    attr_accessor :archived

    sig { params(id: Integer, name: String, archived: T::Boolean, description: T.nilable(String)).void }
    def initialize(id:, name:, archived:, description: nil)
      super()
      @id = id
      @name = name
      @archived = archived
      @description = description
    end
  end
end
