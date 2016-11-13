module Byzantine
  module Handlers
    class PromiseHandler < BaseHandler
      def_delegators :message, :key, :sequence_number, :value

      def handle
        data = session_store.get(key)
        return if data[:sequence_number] != sequence_number || data[:value] != value

        handle_promise data
      end

      private

      def handle_promise(data)
        data[:weak_accepted_count] = (data[:weak_accepted_count] || 0) + 1

        strong_acceptance(data) if !data[:strong_accepted] && weak_quorum?(data)

        session_store.set(key, data)
      end

      def weak_quorum?(data)
        data[:weak_accepted_count] > (distributed.nodes.count + context.fault_tolerance) / 2
      end

      def strong_acceptance(data)
        data[:strong_accepted] = true

        accept_message = Messages::AcceptMessage.new(node_id: node_id, key: key,
                                                     sequence_number: data[:sequence_number])

        distributed.broadcast accept_message
      end
    end
  end
end
