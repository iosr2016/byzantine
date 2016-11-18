module Byzantine
  module Handlers
    class RequestHandler < BaseHandler
      def_delegators :message, :key, :value

      def handle
        number = create_sequence_number
        session_data[:sequence_number] = number
        prepare_message = Messages::PrepareMessage.new node_id: node_id, key: key, sequence_number: number, value: value

        distributed.broadcast prepare_message
      end

      private

      def create_sequence_number
        generator = SequenceGenerator.new base_number: last_sequence_number

        generator.generate_number
      end

      def last_sequence_number
        sequence_numbers = []

        sequence_numbers << session_data[:sequence_number]
        sequence_numbers << session_data[:last_sequence_number]

        sequence_numbers.compact.max
      end
    end
  end
end
