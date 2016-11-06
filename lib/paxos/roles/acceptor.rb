module Paxos
  module Roles
    class Acceptor < BaseRole
      def_delegators :message, :key, :sequence_number, :value, :node_id

      def call
        case message
        when Message::PrepareMessage
          prepare
        when Messages::AcceptMessage
          accept
        end
      end

      private

      def prepare
        last_sequence_number = session_store.get(key)[:sequence_number]
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

        node = distributed.node_by_id node_id
        distributed.send node, Messages::PromiseMessage.new(sequence_number: sequence_number, key: key)
      end
    end
  end
end
