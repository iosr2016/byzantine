module Byzantine
  module Handlers
    class RequestHandler < BaseHandler
      def_delegators :message, :key, :last_sequence_number, :value

      def handle
        number = create_sequence_number
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
        return nil unless session_data && session_data[:sequence_number]

        session_data[:sequence_number]
      end
    end
  end
end
