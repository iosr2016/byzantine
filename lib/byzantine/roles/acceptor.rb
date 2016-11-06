module Byzantine
  module Roles
    class Acceptor < BaseRole
      def_delegators :message, :key, :sequence_number, :value

      def call
        case message
        when Messages::PrepareMessage
          prepare
        when Messages::AcceptMessage
          accept
        end
      end

      private

      def prepare
        data = session_store.get(key)
        last_sequence_number = data ? data[:sequence_number] : 0
        return unless last_sequence_number < sequence_number

        prepare_promise
      end

      def accept
        data = session_store.get(key)
        return unless sequence_number == data[:sequence_number]

        data_store.set(key, data[:value])
      end

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
