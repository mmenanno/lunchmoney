# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "yaml"
require "json"
require_relative "../../generators/openapi_model_generator"

class TestOpenApiModelGenerator < Minitest::Test
  MINIMAL_SPEC = {
    "info" => { "version" => "1.0.0-test" },
    "components" => {
      "schemas" => {
        "userObject" => {
          "type" => "object",
          "properties" => {
            "id" => { "type" => "integer", "format" => "int32" },
            "name" => { "type" => "string" },
            "email" => { "type" => "string" },
          },
          "required" => %w[id name email],
        },
        "insertTransactionObject" => {
          "type" => "object",
          "x-internal" => true,
          "properties" => {
            "date" => { "type" => "string", "format" => "date" },
            "amount" => {
              "oneOf" => [
                { "type" => "number", "format" => "double" },
                { "type" => "string", "pattern" => '^-?\d+(\.\d{1,4})?$' },
              ],
            },
            "payee" => { "type" => "string", "maxLength" => 140 },
            "status" => {
              "type" => "string",
              "enum" => %w[reviewed unreviewed],
            },
            "custom_metadata" => {
              "type" => "object",
              "nullable" => true,
              "additionalProperties" => true,
            },
          },
          "required" => %w[date amount],
        },
        "currencyEnum" => {
          "type" => "string",
          "enum" => %w[usd eur gbp],
        },
        "alignedSummaryResponseObject" => {
          "type" => "object",
          "properties" => {
            "aligned" => { "type" => "boolean", "enum" => [true] },
            "categories" => { "type" => "array" },
          },
        },
        "transactionObject" => {
          "type" => "object",
          "properties" => {
            "id" => { "type" => "integer" },
            "category_id" => { "type" => "integer", "nullable" => true },
            "tag_ids" => { "type" => "array", "items" => { "type" => "integer" } },
          },
        },
      },
    },
    "paths" => {
      "/me" => {
        "get" => {
          "responses" => {
            "200" => {
              "content" => {
                "application/json" => {
                  "example" => { "name" => "Test User", "email" => "test@example.com" },
                },
              },
            },
          },
        },
      },
      "/categories" => {
        "get" => {
          "responses" => {
            "200" => {
              "content" => {
                "application/json" => {
                  "examples" => {
                    "default response" => {
                      "value" => [{ "id" => 1, "name" => "Food" }],
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
  }.freeze

  def setup
    @tmpdir = Dir.mktmpdir
    @spec_file = File.join(@tmpdir, "spec.yaml")
    @output_dir = File.join(@tmpdir, "output")
    FileUtils.mkdir_p(@output_dir)
    File.write(@spec_file, MINIMAL_SPEC.to_yaml)
    @generator = LunchMoney::Generators::OpenApiModelGenerator.new(
      spec_path: @spec_file,
      output_dir: @output_dir,
    )
  end

  def teardown
    FileUtils.rm_rf(@tmpdir)
  end

  def test_generate_creates_model_files
    @generator.generate!
    assert File.exist?(File.join(@output_dir, "user.rb"))
    assert File.exist?(File.join(@output_dir, "insert_transaction.rb"))
    assert File.exist?(File.join(@output_dir, "transaction.rb"))
  end

  def test_generate_creates_enum_files
    @generator.generate!
    assert File.exist?(File.join(@output_dir, "enums", "currency.rb"))
  end

  def test_generate_creates_summary_files
    @generator.generate!
    assert File.exist?(File.join(@output_dir, "summary", "aligned_summary_response.rb"))
  end

  def test_generated_model_inherits_from_base
    @generator.generate!
    content = File.read(File.join(@output_dir, "user.rb"))
    assert_includes content, "class User < Base"
  end

  def test_generated_model_has_header
    @generator.generate!
    content = File.read(File.join(@output_dir, "user.rb"))
    assert_includes content, "AUTO-GENERATED from LunchMoney OpenAPI spec v1.0.0-test"
    assert_includes content, "frozen_string_literal: true"
  end

  def test_generated_model_has_attr_accessors
    @generator.generate!
    content = File.read(File.join(@output_dir, "user.rb"))
    assert_includes content, "attr_accessor :id, :name, :email"
  end

  def test_request_schema_generates_validate_method
    @generator.generate!
    content = File.read(File.join(@output_dir, "insert_transaction.rb"))
    assert_includes content, "def validate!"
    assert_includes content, 'raise ArgumentError, "date is required" if date.nil?'
    assert_includes content, 'raise ArgumentError, "amount is required" if amount.nil?'
  end

  def test_validate_checks_max_length
    @generator.generate!
    content = File.read(File.join(@output_dir, "insert_transaction.rb"))
    assert_includes content, "payee must be at most 140 characters"
  end

  def test_validate_checks_enum
    @generator.generate!
    content = File.read(File.join(@output_dir, "insert_transaction.rb"))
    assert_includes content, 'must be one of: reviewed, unreviewed'
  end

  def test_validate_checks_custom_metadata
    @generator.generate!
    content = File.read(File.join(@output_dir, "insert_transaction.rb"))
    assert_includes content, "custom_metadata must be a Hash"
    assert_includes content, "custom_metadata exceeds 4096 character limit"
  end

  def test_enum_module_has_values_constant
    @generator.generate!
    content = File.read(File.join(@output_dir, "enums", "currency.rb"))
    assert_includes content, "module Currency"
    assert_includes content, "VALUES = %w["
    assert_includes content, "usd"
    assert_includes content, "eur"
    assert_includes content, "gbp"
    assert_includes content, "].freeze"
  end

  def test_summary_model_in_summary_namespace
    @generator.generate!
    content = File.read(File.join(@output_dir, "summary", "aligned_summary_response.rb"))
    assert_includes content, "module Summary"
    assert_includes content, "class AlignedSummaryResponse < Base"
  end

  def test_aligned_response_has_aligned_method
    @generator.generate!
    content = File.read(File.join(@output_dir, "summary", "aligned_summary_response.rb"))
    assert_includes content, "def aligned?"
    assert_includes content, "true"
  end

  def test_hydration_methods_for_id_fields
    @generator.generate!
    content = File.read(File.join(@output_dir, "transaction.rb"))
    assert_includes content, "def category(client:)"
    assert_includes content, "hydrate(:category, client: client)"
    assert_includes content, "def tags(client:)"
    assert_includes content, "hydrate(:tags, client: client)"
  end

  def test_generate_fixtures_creates_json_files
    fixture_dir = File.join(@tmpdir, "fixtures")
    FileUtils.mkdir_p(fixture_dir)
    fixture_gen = LunchMoney::Generators::OpenApiModelGenerator.new(
      spec_path: @spec_file,
      output_dir: fixture_dir,
    )
    fixture_gen.generate_fixtures!
    assert File.exist?(File.join(fixture_dir, "me.json"))
    me_data = JSON.parse(File.read(File.join(fixture_dir, "me.json")))
    assert_equal "Test User", me_data["name"]
  end

  def test_generated_ruby_is_syntactically_valid
    @generator.generate!
    Dir.glob(File.join(@output_dir, "**", "*.rb")).each do |file|
      result = `ruby -c #{file} 2>&1`
      assert_includes result, "Syntax OK", "#{file} has syntax errors: #{result}"
    end
  end

  def test_idempotent_generation
    @generator.generate!
    first_run = {}
    Dir.glob(File.join(@output_dir, "**", "*.rb")).each do |file|
      first_run[file] = File.read(file)
    end

    @generator.generate!
    Dir.glob(File.join(@output_dir, "**", "*.rb")).each do |file|
      assert_equal first_run[file], File.read(file), "#{file} changed on second run"
    end
  end
end
