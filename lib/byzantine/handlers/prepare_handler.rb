module Byzantine
  module Handlers
    class PrepareHandler < BaseHandler
      def_delegators :message, :key, :sequence_number, :value

      def handle
        data = session_store.get(key)
        last_sequence_number = data ? data[:sequence_number] : 0
        return unless last_sequence_number < sequence_number

        prepare_promise
      end

      private

      def prepare_promise
        session_store.set(key, sequence_number: sequence_number, value: value)

        node = distributed.node_by_id message.node_id
        distributed.send node, promise_mesage
      end

      def promise_mesage
        Messages::PromiseMessage.new(node_id: node_id, key: key, sequence_number: sequence_number)
      end
    end
  end
end
