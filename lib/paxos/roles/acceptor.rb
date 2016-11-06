module Paxos
  module Roles
    module Acceptor
      def prepare(message)
        sequence_number = session_store.get(message.key)[:sequence_number]
        return unless sequence_number < message.sequence_number

        promise(message)
      end

      def accept(message)
        data = session_store.get(message.key)
        return unless sequence_number == data

        data_store.set(message.key, data[:value])
      end

      private

      def promise(message)
        session_store.set(message.key, sequence_number: message.sequence_number, value: message.value)

        node = distributed.node_by_id message.node_id
        distributed.send node, Messages::PromiseMessage.new(sequence_number: message.sequence_number, key: message.key)
      end
    end
  end
end
