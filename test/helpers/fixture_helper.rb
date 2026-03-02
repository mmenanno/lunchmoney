# frozen_string_literal: true

module FixtureHelper
  FIXTURE_PATH = File.expand_path("../fixtures/responses", __dir__)

  def fixture_json(name)
    File.read(File.join(FIXTURE_PATH, "#{name}.json"))
  end

  def fixture(name)
    JSON.parse(fixture_json(name), symbolize_names: true)
  end
end
