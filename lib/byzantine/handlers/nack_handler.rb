module Byzantine
  module Handlers
    class NackHandler < BaseHandler
      def_delegators :message, :key, :last_sequence_number

      def handle
        session_data[:nack_count]                = (session_data[:nack_count] || 0) + 1
        session_data[:max_nack_sequence_number]  = max_nack_sequence_number

        handle_nack if reject_quorum?

        session_store.set(key, session_data)
      end

      private

      def max_nack_sequence_number
        [session_data[:max_nack_sequence_number], last_sequence_number].compact.max
      end

      def reject_quorum?
        session_data[:nack_count] > (distributed.nodes.count + context.fault_tolerance) / 2
      end

      def handle_nack
        session_data[:nack_count]           = 0
        session_data[:last_sequence_number] = session_data.delete(:max_nack_sequence_number)

        message = Messages::RequestMessage.new(node_id: node_id, key: key, value: session_data[:value])
        Handlers::RequestHandler.new(context, message).handle
      end
    end
  end
end
