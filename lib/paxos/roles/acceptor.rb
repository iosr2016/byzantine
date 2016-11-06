module Paxos
  module Roles
    module Acceptor
      def prepare(node_id, key, proposal_sequence_number, value)
        sequence_number = session_store.get(key)[:sequence_number]
        return unless sequence_number < proposal_sequence_number

        promise(node_id, key, proposal_sequence_number, value)
      end

      def accept(node_id, key, sequence_number)
        key_data = session_store.get(key)
        return unless sequence_number == key_data

        data_store.set(key, data[:value])
        node = distributed.node_by_id node_id
        distributed.send node, Messages::AcceptedMessage.new(sequence_number: proposal_sequence_number, key: key)
      end

      private

      def promise(node_id, key, sequence_number, value)
        session_store.set(key, sequence_number: sequence_number, value: value)

        node = distributed.node_by_id node_id
        distributed.send node, Messages::PromiseMessage.new(sequence_number: sequence_number, key: key)
      end
    end
  end
end
