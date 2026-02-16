# frozen_string_literal: true

require "test_helper"
require "active_support/core_ext/numeric/time.rb"

class VcrTest < ActiveSupport::TestCase
  class << self
    def all_cassette_files
      Dir.glob("#{__dir__}/cassettes/**/*.yml")
    end

    def extract_cassette_name(cassette)
      match = cassette.match(%r{^.+/cassettes/(?<name>.+)\.yml})

      match[:name] || "unknown_cassette_name"
    end
  end

  def extract_recorded_at_from_cassette(cassette)
    serializer = VCR.cassette_serializers[:yaml]
    deserialized_hash = serializer.deserialize(File.read(cassette))["http_interactions"]

    wrapped_hash = deserialized_hash.map { |hash| VCR::HTTPInteraction.from_hash(hash) }.tap do |interactions|
      interactions.reject! do |interaction|
        interaction.request.uri.is_a?(String) && VCR.request_ignorer.ignore?(interaction.request)
      end
    end

    wrapped_hash.map(&:recorded_at).min
  end

  all_cassette_files.each do |cassette|
    cassette_name = extract_cassette_name(cassette)

    test "#{cassette_name} cassette is not over 365 days old" do
      assert_operator(extract_recorded_at_from_cassette(cassette), :>, 365.days.ago.utc)
    end
  end
end
