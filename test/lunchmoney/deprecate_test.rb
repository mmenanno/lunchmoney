# frozen_string_literal: true

require "test_helper"

class DeprecateTest < ActiveSupport::TestCase
  setup do
    @deprecate_test_klass = LunchMoney::Calls::DeprecateTestCalls
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

    Kernel.expects(:warn).with(regexp_matches(/\[WARNING\] .+deprecated .+Please use #new_endpoint/))

    @deprecate_test_klass.new.old_endpoint_with_replacement
  end

  test "deprecate_endpoint warns with no replacement message when replacement is not provided" do
    @deprecate_test_klass.any_instance.expects(:endpoint_deprecation_warnings).returns(true)

    Kernel.expects(:warn).with(regexp_matches(/\[WARNING\] .+There is currently no replacement for this endpoint/))

    @deprecate_test_klass.new.old_endpoint_no_replacement
  end

  test "deprecate_endpoint respects different severity levels" do
    @deprecate_test_klass.any_instance.expects(:endpoint_deprecation_warnings).returns(true).times(3)

    # Test error level
    Kernel.expects(:warn).with(regexp_matches(/\[ERROR\]/))
    @deprecate_test_klass.new.old_endpoint_error_level

    # Test info level
    Kernel.expects(:warn).with(regexp_matches(/\[INFO\]/))
    @deprecate_test_klass.new.old_endpoint_info_level

    # Test warning level (default)
    Kernel.expects(:warn).with(regexp_matches(/\[WARNING\]/))
    @deprecate_test_klass.new.old_endpoint_no_replacement
  end

  test "deprecate_endpoint is silenced by environment variable" do
    @deprecate_test_klass.any_instance.expects(:endpoint_deprecation_warnings).returns(true)
    ENV.expects(:[]).with("SILENCE_LUNCHMONEY_DEPRECATIONS").returns("true")

    Kernel.expects(:warn).never

    @deprecate_test_klass.new.old_endpoint_no_replacement
  end
end
