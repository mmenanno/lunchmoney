# frozen_string_literal: true

tool :models do
  desc "Regenerate model objects from OpenAPI spec"

  flag :spec, "--spec PATH", default: "openapi/v2.yaml"
  flag :output, "--output PATH", default: "lib/lunchmoney/objects"

  include :exec, exit_on_nonzero_status: true
  include :terminal

  def run
    require_relative "../generators/openapi_model_generator"

    generator = LunchMoney::Generators::OpenApiModelGenerator.new(
      spec_path: spec,
      output_dir: output,
    )

    puts("Generating models from #{spec}...", :blue, :bold)
    generator.generate!
    puts("Models generated in #{output}/", :green, :bold)
  end
end

tool :fixtures do
  desc "Regenerate test fixtures from OpenAPI spec examples"

  flag :spec, "--spec PATH", default: "openapi/v2.yaml"
  flag :output, "--output PATH", default: "test/fixtures/responses"

  include :exec, exit_on_nonzero_status: true
  include :terminal

  def run
    require_relative "../generators/openapi_model_generator"

    generator = LunchMoney::Generators::OpenApiModelGenerator.new(
      spec_path: spec,
      output_dir: output,
    )

    puts("Extracting fixtures from #{spec}...", :blue, :bold)
    generator.generate_fixtures!
    puts("Fixtures generated in #{output}/", :green, :bold)
  end
end
