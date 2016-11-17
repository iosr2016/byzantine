module Byzantine
  module Handlers
    class PrepareHandler < BaseHandler
      def_delegators :message, :key, :sequence_number, :value

      def handle
        data = session_data || data_store.get(key)
        last_sequence_number = data && data[:sequence_number] ? data[:sequence_number] : 0
        if last_sequence_number < sequence_number
          weak_acceptance
        else
          reject_prepare(last_sequence_number)
        end
      end

      private

      def weak_acceptance
        session_store.set(key, sequence_number: sequence_number, value: value)

        send_promise
      end

      def send_promise
        promise_message = Messages::PromiseMessage.new(node_id: node_id, key: key, sequence_number: sequence_number,
                                                       value: value)
        distributed.broadcast promise_message

        buffered_messages = message_buffer.flush(key, promise_message.class)
        buffered_messages.each { |m| message_handler.handle(m) }
      end

      def reject_prepare(last_sequence_number)
        response_message = Messages::NackMessage.new(node_id: node_id, key: key,
                                                     last_sequence_number: last_sequence_number)

        node = distributed.node_by_id message.node_id
        distributed.send node, response_message
      end
    end
  end
end
