module Byzantine
  module Handlers
    class PrepareHandler < BaseHandler
      def_delegators :message, :key, :sequence_number, :value

      def handle
        data = session_store.get(key)
        last_sequence_number = data ? data[:sequence_number] : 0

        message = if last_sequence_number < sequence_number
                    prepare_promise
                  else
                    prepare_nack(last_sequence_number)
                  end

        send_message message
      end

      private

      def prepare_promise
        session_store.set(key, sequence_number: sequence_number, value: value)
        Messages::PromiseMessage.new(node_id: node_id, key: key, sequence_number: sequence_number)
      end

      def prepare_nack(last_sequence_number)
        Messages::NackMessage.new(node_id: node_id, key: key, last_sequence_number: last_sequence_number)
      end

      def send_message(response_message)
        node = distributed.node_by_id message.node_id
        distributed.send node, response_message
      end
    end
  end
end
