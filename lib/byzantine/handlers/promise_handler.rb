module Byzantine
  module Handlers
    class PromiseHandler < BaseHandler
      def_delegators :message, :key, :sequence_number

      def handle
        data = session_store.get(key)
        return if data[:sequence_number] != sequence_number

        handle_promise data
      end

      private

      def handle_promise(data)
        data[:received_promise_number] = (data[:received_promise_number] || 0) + 1

        if !data[:accepted] && quorum?(data)
          accept_value data
        else
          session_store.set(key, data)
        end
      end

      def quorum?(data)
        data[:received_promise_number] >= (distributed.nodes.count + 1) / 2
      end

      def accept_value(data)
        data[:accepted] = true

        data_store.set(key, data[:value])
        session_store.set(key, data)
        accept_message = Messages::AcceptMessage.new(node_id: node_id, key: key,
                                                     sequence_number: data[:sequence_number])
        distributed.broadcast accept_message
      end
    end
  end
end
