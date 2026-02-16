# frozen_string_literal: true

require "yaml"
require "json"
require "fileutils"

module LunchMoney
  module Generators
    class OpenApiModelGenerator
      HEADER = <<~RUBY
        # frozen_string_literal: true

        # AUTO-GENERATED from LunchMoney OpenAPI spec v%{version}
        # Do not edit manually. Run `toys generate models` to regenerate.
      RUBY

      # Schemas that should generate validate! methods (request/write schemas)
      REQUEST_SCHEMA_PATTERNS = %w[
        insert
        update
        create
        split
      ].freeze

      # Schemas that are standalone enums (not object schemas)
      ENUM_SCHEMA_SUFFIX = "Enum"

      # Summary schemas go into a subdirectory
      SUMMARY_PREFIXES = %w[
        aligned
        nonAligned
        summary
      ].freeze

      # Schema name overrides for cases where the spec name doesn't match
      # the desired Ruby class name
      CLASS_NAME_OVERRIDES = {
        "recurringObject" => "RecurringItem",
        "skippedExistingExternalIdObject" => "SkippedDuplicate",
      }.freeze

      # ID field to hydration method mapping
      HYDRATION_MAP = {
        "category_id" => { method: "category", single: true },
        "manual_account_id" => { method: "manual_account", single: true },
        "plaid_account_id" => { method: "plaid_account", single: true },
        "tag_ids" => { method: "tag", single: false },
      }.freeze

      def initialize(spec_path:, output_dir:)
        @spec = YAML.safe_load(File.read(spec_path), permitted_classes: [Date, Time])
        @output_dir = output_dir
        @spec_path = spec_path
      end

      def generate!
        schemas = @spec.dig("components", "schemas") || {}
        schemas.each do |name, schema|
          if enum_schema?(name, schema)
            generate_enum(name, schema)
          elsif schema["type"] == "object" || schema["properties"]
            generate_model(name, schema)
          end
        end
      end

      def generate_fixtures!
        paths = @spec["paths"] || {}
        paths.each do |path, methods|
          methods.each do |method, detail|
            next unless detail.is_a?(Hash) && detail["responses"]

            resource = fixture_resource_name(path)
            action = fixture_action_name(method, path)

            detail["responses"].each do |code, resp|
              next unless resp.is_a?(Hash)

              content = resp.dig("content", "application/json")
              next unless content

              if content["example"]
                write_fixture(resource, action, code, content["example"])
              elsif content["examples"]
                content["examples"].each do |example_name, example_data|
                  next unless example_data.is_a?(Hash) && example_data["value"]

                  fixture_name = fixture_example_name(action, example_name)
                  write_fixture(resource, fixture_name, code, example_data["value"])
                end
              end
            end
          end
        end
      end

      private

      def spec_version
        @spec.dig("info", "version") || "unknown"
      end

      def header
        format(HEADER, version: spec_version)
      end

      # --- Enum generation ---

      def enum_schema?(name, schema)
        name.end_with?(ENUM_SCHEMA_SUFFIX) && schema["enum"]
      end

      def generate_enum(name, schema)
        module_name = enum_module_name(name)
        file_name = camel_to_snake(module_name)
        values = schema["enum"]

        code = <<~RUBY
          #{header.strip}

          module LunchMoney
            module Objects
              module Enums
                module #{module_name}
                  VALUES = %w[
          #{values.map { |v| "            #{v}" }.join("\n")}
                  ].freeze
                end
              end
            end
          end
        RUBY

        dir = File.join(@output_dir, "enums")
        FileUtils.mkdir_p(dir)
        File.write(File.join(dir, "#{file_name}.rb"), code)
      end

      def enum_module_name(schema_name)
        schema_name.sub(/Enum$/, "").then { |n| n[0].upcase + n[1..] }
      end

      # --- Model generation ---

      def generate_model(name, schema)
        class_name = schema_to_class_name(name)
        file_name = camel_to_snake(class_name)
        properties = schema["properties"] || {}
        required_fields = schema["required"] || []
        is_request = request_schema?(name)
        is_summary = summary_schema?(name)

        lines = []
        lines << header.strip
        lines << ""

        # Require json if we need it for validate!
        if is_request && has_custom_metadata?(properties)
          lines << 'require "json"'
          lines << ""
        end

        lines << "module LunchMoney"
        lines << "  module Objects"

        if is_summary
          lines << "    module Summary"
          lines << "      class #{class_name} < Base"
          indent = "        "
        else
          lines << "    class #{class_name} < Base"
          indent = "      "
        end

        # Generate attr_accessors
        accessor_names = properties.keys.map { |k| ":#{k}" }
        if accessor_names.any?
          wrapped = wrap_accessors(accessor_names, indent)
          lines << "#{indent}attr_accessor #{wrapped}"
        end

        # Generate aligned? method for summary response objects
        if name == "alignedSummaryResponseObject"
          lines << ""
          lines << "#{indent}def aligned?"
          lines << "#{indent}  true"
          lines << "#{indent}end"
        elsif name == "nonAlignedSummaryResponseObject"
          lines << ""
          lines << "#{indent}def aligned?"
          lines << "#{indent}  false"
          lines << "#{indent}end"
        end

        # Generate lazy hydration methods (only for non-request, non-summary read objects)
        unless is_request || is_summary
          hydration_methods = generate_hydration_methods(properties, indent)
          if hydration_methods.any?
            lines << ""
            hydration_methods.each { |m| lines << m }
          end
        end

        # Generate validate! for request schemas
        if is_request
          validations = generate_validations(properties, required_fields, indent)
          if validations.any?
            lines << ""
            lines << "#{indent}def validate!"
            validations.each { |v| lines << v }
            lines << "#{indent}end"
          end
        end

        if is_summary
          lines << "      end"
          lines << "    end"
        else
          lines << "    end"
        end
        lines << "  end"
        lines << "end"
        lines << ""

        # Write to file
        dir = is_summary ? File.join(@output_dir, "summary") : @output_dir
        FileUtils.mkdir_p(dir)
        File.write(File.join(dir, "#{file_name}.rb"), lines.join("\n"))
      end

      def schema_to_class_name(name)
        # Check for explicit overrides first
        return CLASS_NAME_OVERRIDES[name] if CLASS_NAME_OVERRIDES.key?(name)

        # Remove "Object" suffix if present
        clean = name.sub(/Object$/, "")
        # Remove "RequestObject" pattern
        clean = clean.sub(/Request$/, "")
        # Handle camelCase to PascalCase
        clean[0].upcase + clean[1..]
      end

      def camel_to_snake(name)
        name.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
            .gsub(/([a-z\d])([A-Z])/, '\1_\2')
            .downcase
      end

      def wrap_accessors(names, indent)
        return names.first if names.length == 1

        # Wrap at ~100 chars per line
        result = []
        current_line = names.first
        names[1..].each do |name|
          if (indent.length + "attr_accessor ".length + current_line.length + ", ".length + name.length) > 100
            result << current_line + ","
            current_line = indent + " " * "attr_accessor ".length + name
          else
            current_line += ", #{name}"
          end
        end
        result << current_line
        result.join("\n")
      end

      def request_schema?(name)
        lower = name.downcase
        REQUEST_SCHEMA_PATTERNS.any? { |pattern| lower.include?(pattern) } &&
          !name.include?("Response")
      end

      def summary_schema?(name)
        SUMMARY_PREFIXES.any? { |prefix| name.start_with?(prefix) }
      end

      def has_custom_metadata?(properties)
        properties.key?("custom_metadata")
      end

      # --- Hydration ---

      def generate_hydration_methods(properties, indent)
        methods = []
        properties.each_key do |prop_name|
          hydration = HYDRATION_MAP[prop_name]
          next unless hydration

          if hydration[:single]
            methods << "#{indent}def #{hydration[:method]}(client:)"
            methods << "#{indent}  return nil unless #{prop_name}"
            methods << "#{indent}  hydrate(:#{hydration[:method]}, client: client) { |c| c.#{hydration[:method]}(#{prop_name}) }"
            methods << "#{indent}end"
            methods << ""
          else
            method_name = hydration[:method] + "s"
            methods << "#{indent}def #{method_name}(client:)"
            methods << "#{indent}  return [] if #{prop_name}.nil? || #{prop_name}.empty?"
            methods << "#{indent}  hydrate(:#{method_name}, client: client) { |c| #{prop_name}.map { |id| c.#{hydration[:method]}(id) } }"
            methods << "#{indent}end"
            methods << ""
          end
        end
        methods.pop if methods.last == "" # Remove trailing blank line
        methods
      end

      # --- Validation ---

      def generate_validations(properties, required_fields, indent)
        validations = []

        # Required field checks
        required_fields.each do |field|
          validations << "#{indent}  raise ArgumentError, \"#{field} is required\" if #{field}.nil?"
        end

        # Property-specific validations
        properties.each do |prop_name, prop_def|
          # maxLength
          if prop_def["maxLength"]
            validations << "#{indent}  raise ArgumentError, " \
              "\"#{prop_name} must be at most #{prop_def["maxLength"]} characters\" " \
              "if #{prop_name} && #{prop_name}.to_s.length > #{prop_def["maxLength"]}"
          end

          # minLength (only if > 0)
          if prop_def["minLength"] && prop_def["minLength"] > 0
            validations << "#{indent}  raise ArgumentError, " \
              "\"#{prop_name} must be at least #{prop_def["minLength"]} characters\" " \
              "if #{prop_name} && #{prop_name}.to_s.length < #{prop_def["minLength"]}"
          end

          # pattern
          if prop_def["pattern"]
            validations << "#{indent}  raise ArgumentError, " \
              "\"#{prop_name} does not match expected pattern\" " \
              "if #{prop_name} && !#{prop_name}.to_s.match?(/#{prop_def["pattern"]}/)"
          end

          # enum
          if prop_def["enum"]
            values_str = prop_def["enum"].map(&:inspect).join(", ")
            validations << "#{indent}  raise ArgumentError, " \
              "\"#{prop_name} must be one of: #{prop_def["enum"].join(", ")}\" " \
              "if #{prop_name} && ![#{values_str}].include?(#{prop_name})"
          end

          # custom_metadata size check
          if prop_name == "custom_metadata"
            validations << "#{indent}  if #{prop_name} && !#{prop_name}.is_a?(Hash)"
            validations << "#{indent}    raise ArgumentError, \"#{prop_name} must be a Hash\""
            validations << "#{indent}  end"
            validations << "#{indent}  if #{prop_name} && JSON.generate(#{prop_name}).length > 4096"
            validations << "#{indent}    raise ArgumentError, \"#{prop_name} exceeds 4096 character limit\""
            validations << "#{indent}  end"
          end
        end

        validations
      end

      # --- Fixture generation ---

      def fixture_resource_name(path)
        # /me -> "me", /categories -> "categories", /categories/{id} -> "categories"
        # /transactions/{transaction_id}/attachments -> "transactions/attachments"
        parts = path.split("/").reject { |p| p.empty? || p.start_with?("{") }
        return parts.first if parts.length == 1

        parts.join("/")
      end

      def fixture_action_name(method, path)
        parts = path.split("/").reject(&:empty?)
        has_id = parts.any? { |p| p.start_with?("{") }

        case method.downcase
        when "get"
          has_id ? "get" : "list"
        when "post"
          # Special cases for named actions
          last_part = parts.last
          if last_part.start_with?("{")
            "create"
          elsif %w[group split fetch].include?(last_part)
            last_part
          else
            "create"
          end
        when "put"
          has_id ? "update" : "bulk_update"
        when "delete"
          has_id ? "delete" : "bulk_delete"
        end
      end

      def fixture_example_name(action, example_name)
        # Convert example name to snake_case file-safe name
        clean = example_name.downcase
                            .gsub(/[^a-z0-9\s]/, "")
                            .strip
                            .gsub(/\s+/, "_")
        "#{action}_#{clean}"
      end

      # Singular resources write as top-level files, not subdirectories
      SINGULAR_RESOURCES = %w[me].freeze

      def write_fixture(resource, name, code, data)
        # Only write success responses (2xx)
        return unless code.to_s.start_with?("2")

        if SINGULAR_RESOURCES.include?(resource)
          file_path = File.join(@output_dir, "#{resource}.json")
        else
          FileUtils.mkdir_p(File.join(@output_dir, resource))
          file_path = File.join(@output_dir, resource, "#{name}.json")
        end

        File.write(file_path, JSON.pretty_generate(data) + "\n")
      end
    end
  end
end
