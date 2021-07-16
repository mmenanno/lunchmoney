# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"

module T
  class Struct
    extend T::Sig
    sig { returns(T.untyped) }
    def wrap_and_serialize
      { object_name => serialize }
    end

    private

    sig { returns(String) }
    def object_name
      T.must(T.must(self.class.name).split("::")[1]).downcase
    end
  end
end
