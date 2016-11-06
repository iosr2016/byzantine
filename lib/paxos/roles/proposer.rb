module Paxos
  module Roles
    class Proposer < BaseRole
      def_delegators :message, :key, :sequence_number, :value

      def call
        case message
        when Paxos::Messages::RequestMessage
          request
        when Paxos::Messages::PromiseMessage
          promise
        end
      end

      private

      def request
        number = create_sequence_number
        session_store.set(key, sequence_number: number, value: value)
        prepare_message = Paxos::Messages::PrepareMessage.new key: key, sequence_number: number, value: value

        distributed.broadcast prepare_message
      end

      def promise
        data = session_store.get(key)
        return if data[:sequence_number] != sequence_number

        handle_promise data
      end

      def create_sequence_number
        data = session_store.get(key)
        return data[:sequence_number] + 1 if data[:sequence_number]

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
        data[:received_promise_number] > distributed.nodes.count / 2 + 1
      end

      def accept_value(data)
        data[:accepted] = true

        data_sotre.set(key, data[:value])
        session_store.set(key, data)

        distributed.broadcast Paxos::Messages::AcceptMessage.new(key: data[:key],
                                                                 sequence_number: data[:sequence_number])
      end
    end
  end
end
