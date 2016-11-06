module Byzantine
  module Handlers
    class RequestHandler < BaseHandler
      def_delegators :message, :key, :sequence_number, :value

      def handle
        number = create_sequence_number
        session_store.set(key, sequence_number: number, value: value)
        prepare_message = Messages::PrepareMessage.new node_id: node_id, key: key, sequence_number: number, value: value

        distributed.broadcast prepare_message
      end

      private

      def create_sequence_number
        data = session_store.get(key)
        return data[:sequence_number] + 1 if data && data[:sequence_number]

        SequenceGenerator.new.generate_number
      end
    end
  end
end
