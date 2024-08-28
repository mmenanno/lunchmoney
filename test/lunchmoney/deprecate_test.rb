# typed: strict
# frozen_string_literal: true

require "test_helper"

class DeprecateTest < ActiveSupport::TestCase
  setup do
    @deprecate_test_klass = T.let(
      LunchMoney::Calls::DeprecateTestCalls,
      T.class_of(LunchMoney::Calls::DeprecateTestCalls),
    )
  end

  test "deprecate_endpoint does not warn when endpoint_deprecation_warnings is false" do
    @deprecate_test_klass.any_instance.expects(:endpoint_deprecation_warnings).returns(false)

    Kernel.expects(:warn).never

    @deprecate_test_klass.new.old_endpoint_no_replacement
  end

  test "deprecate_endpoint warns when endpoint_deprecation_warnings is true" do
    @deprecate_test_klass.any_instance.expects(:endpoint_deprecation_warnings).returns(true)

    Kernel.expects(:warn).with(regexp_matches(/is deprecated and may be removed from LunchMoney/))

    @deprecate_test_klass.new.old_endpoint_no_replacement
  end

  test "deprecate_endpoint warns with replacement message when replacement is provided" do
    @deprecate_test_klass.any_instance.expects(:endpoint_deprecation_warnings).returns(true)

    call_locations = [mock(label: "old_endpoint_with_replacement", to_s: "lunchmoney/calls/deprecate_test_calls.rb:10")]
    Kernel.expects(:caller_locations).returns(call_locations)

    Kernel.expects(:warn).with(regexp_matches(/old_endpoint_with_replacement is deprecated .+Please use #new_endpoint/))

    @deprecate_test_klass.new.old_endpoint_with_replacement
  end

  test "deprecate_endpoint warns with no replacement message when replacement is not provided" do
    @deprecate_test_klass.any_instance.expects(:endpoint_deprecation_warnings).returns(true)

    Kernel.expects(:warn).with(regexp_matches(/There is currently no replacement for this endpoint/))

    @deprecate_test_klass.new.old_endpoint_no_replacement
  end
end
