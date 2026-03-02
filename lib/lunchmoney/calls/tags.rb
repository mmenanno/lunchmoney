# frozen_string_literal: true

module LunchMoney
  module Calls
    module Tags
      include Base

      # List all tags.
      #
      # @return [Array<LunchMoney::Objects::Tag>]
      def tags
        data = get("/tags")
        build_collection(Objects::Tag, data, key: :tags)
      end

      # Get a single tag by ID.
      #
      # @param id [Integer]
      # @return [LunchMoney::Objects::Tag]
      # @raise [LunchMoney::NotFoundError] if tag does not exist
      def tag(id)
        data = get("/tags/#{id}")
        build_object(Objects::Tag, data)
      end

      # Create a tag.
      #
      # @param attrs [Hash] tag attributes (name:, description:, text_color:, background_color:)
      # @return [LunchMoney::Objects::Tag]
      def create_tag(**attrs)
        data = post("/tags", body: attrs)
        build_object(Objects::Tag, data)
      end

      # Update a tag.
      #
      # @param id [Integer]
      # @param attrs [Hash] attributes to update (name:, description:, text_color:, background_color:)
      # @return [LunchMoney::Objects::Tag]
      def update_tag(id, **attrs)
        data = put("/tags/#{id}", body: attrs)
        build_object(Objects::Tag, data)
      end

      # Delete a tag.
      #
      # @param id [Integer]
      # @return [nil]
      def delete_tag(id)
        delete("/tags/#{id}")
      end
    end
  end
end
