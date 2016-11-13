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

        if !data[:strong_accepted] && weak_quorum?(data)
          strong_acceptance data # TODO: let's wait for all responses before strong_acceptance
        else
          session_store.set(key, data)
        end
      end

      def weak_quorum?(data)
        data[:weak_accepted_count] > (distributed.nodes.count + configuration.fault_tolerance) / 2
      end

      def strong_acceptance(data)
        data[:strong_accepted] = true
        session_store.set(key, data)

        accept_message = Messages::AcceptMessage.new(node_id: node_id, key: key,
                                                     sequence_number: data[:sequence_number])

        distributed.broadcast accept_message
      end
    end
  end
end
