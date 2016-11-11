module Byzantine
  module Handlers
    class RequestHandler < BaseHandler
      def_delegators :message, :key, :last_sequence_number, :value

      def handle
        number = create_sequence_number
        session_store.set(key, sequence_number: number, value: value)
        prepare_message = Messages::PrepareMessage.new node_id: node_id, key: key, sequence_number: number, value: value

        distributed.broadcast prepare_message
      end

      private

      def create_sequence_number
        previous_number = last_sequence_number || read_last_sequence_number
        generator = SequenceGenerator.new base_number: previous_number

        generator.generate_number
      end

      def read_last_sequence_number
        data = session_store.get(key)
        return nil unless data || data[:sequence_number]

        data[:sequence_number]
      end
    end
  end
end
