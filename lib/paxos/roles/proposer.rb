module Paxos
  module Roles
    module Proposer
      def request(key, value)
        number = sequence_number key
        session_store.set(key, sequence_number: number, value: value)
        message = Messages::PrepareMessage.new key: key, sequence_number: number, value: value

        distributed.broadcast message
      end

      def promise(sequence_number, key)
        data = session_store.get(key)
        return if data[:sequence_number] != sequence_number

        data[:received_promise_number] = (data[:received_promise_number] || 0) + 1

        if !data[:accepted] && quorum?(data)
          accept_value data
        else
          session_store.set(key, data)
        end
      end

      private

      def sequence_number(key)
        number_value = session_store.get(key)
        return number_value[:sequence_number] + 1 if number_value[:sequence_number]

        SequenceGenerator.new.generate_number
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
