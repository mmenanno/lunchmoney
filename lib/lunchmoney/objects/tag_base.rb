# frozen_string_literal: true

module LunchMoney
  module Objects
    # https://lunchmoney.dev/#tags-object without some fields. This is used within field returns of other objects like
    # field returns of other objects like transactions
    class TagBase < LunchMoney::Objects::Object
      attr_accessor :id

      attr_accessor :name

      def initialize(id:, name:)
        super()
        @id = id
        @name = name
      end
    end
  end
end
