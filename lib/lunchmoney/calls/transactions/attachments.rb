# frozen_string_literal: true

module LunchMoney
  module Calls
    module Transactions
      module Attachments
        include Base

        # List attachments for a transaction.
        #
        # @param transaction_id [Integer]
        # @return [Array<LunchMoney::Objects::TransactionAttachment>]
        def attachments(transaction_id:)
          data = get("/transactions/#{transaction_id}/attachments")
          build_collection(Objects::TransactionAttachment, data, key: :attachments)
        end

        # Upload a file attachment to a transaction.
        #
        # @param transaction_id [Integer]
        # @param file_path [String] path to file on disk (max 10MB)
        # @param notes [String, nil] optional description
        # @return [LunchMoney::Objects::TransactionAttachment]
        def attach_file(transaction_id:, file_path:, notes: nil)
          params = {}
          params[:notes] = notes if notes
          data = upload("/transactions/#{transaction_id}/attachments", file: file_path, **params)
          build_object(Objects::TransactionAttachment, data)
        end

        # Get a signed download URL for an attachment.
        #
        # @param id [Integer] attachment ID
        # @return [LunchMoney::Objects::TransactionAttachment]
        def attachment_url(id)
          data = get("/transactions/attachments/#{id}")
          build_object(Objects::TransactionAttachment, data)
        end

        # Delete an attachment.
        #
        # @param id [Integer] attachment ID
        # @return [nil]
        def delete_attachment(id)
          delete("/transactions/attachments/#{id}")
        end
      end
    end
  end
end
