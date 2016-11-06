require 'pry'
module Byzantine
  module Roles
    class Proposer < BaseRole
      def_delegators :message, :key, :sequence_number, :value

      def call
        case message
        when Messages::RequestMessage
          request
        when Messages::PromiseMessage
          promise
        end
      end

      private

      def request
        number = create_sequence_number
        session_store.set(key, sequence_number: number, value: value)
        prepare_message = Messages::PrepareMessage.new node_id: node_id, key: key, sequence_number: number, value: value

        distributed.broadcast prepare_message
      end

      def promise
        data = session_store.get(key)
        return if data[:sequence_number] != sequence_number

        handle_promise data
      end

      def create_sequence_number
        previous_sequence_number = session_store.get(key)[:sequence_number]
        return previous_sequence_number + 1 if previous_sequence_number

        SequenceGenerator.new.generate_number
      end

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
