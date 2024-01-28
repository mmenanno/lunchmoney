# typed: strict
# frozen_string_literal: true

module FakeResponseDataHelper
  private

  sig { returns(T::Hash[Symbol, String]) }
  def fake_general_error
    { error: "This is an error" }
  end
end
