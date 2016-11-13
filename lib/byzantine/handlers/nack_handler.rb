module Byzantine
  module Handlers
    class NackHandler < BaseHandler
      def_delegators :message, :key, :last_sequence_number

      def handle
        data                            = session_store.get(key)
        data[:nack_count]               = (data[:nack_count] || 0) + 1
        data[:max_nack_sequence_number] = [data[:last_sequence_number], last_sequence_number].compact.max

        handle_nack(data) if faulty_quorum?(data)

        session_store.set(key, data)
      end

      private

      def faulty_quorum?(data)
        data[:nack_count] > configuration.fault_tolerance
      end

      def handle_nack(data)
        data[:nack_count] = 0
        message = Messages::RequestMessage.new(node_id: node_id, key: key, value: data[:value],
                                               last_sequence_number: data[:max_nack_sequence_number])
        Handlers::RequestHandler.new(context, message).handle
      end
    end
  end
end
