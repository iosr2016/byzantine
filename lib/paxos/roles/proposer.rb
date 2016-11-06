module Paxos
  module Roles
    module Proposer
      def request(message)
        number = sequence_number message.key
        session_store.set(message.key, sequence_number: number, value: message.value)
        prepare_message = Messages::PrepareMessage.new key: message.key, sequence_number: number, value: message.value

        distributed.broadcast prepare_message
      end

      def promise(message)
        data = session_store.get(message.key)
        return if data[:sequence_number] != message.sequence_number

        handle_promise message.key, data
      end

      private

      def sequence_number(key)
        number_value = session_store.get(key)
        return number_value[:sequence_number] + 1 if number_value[:sequence_number]

        SequenceGenerator.new.generate_number
      end

      def handle_promise(key, data)
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

        distributed.broadcast Messages::AcceptMessage.new(key: data[:key], sequence_number: data[:sequence_number])
      end
    end
  end
end
