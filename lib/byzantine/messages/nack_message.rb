module Byzantine
  module Messages
    class NackMessage < BaseMessage
      attr_reader :last_sequence_number

      def initialize(node_id:, key:, last_sequence_number:)
        super node_id: node_id, key: key
        @last_sequence_number = last_sequence_number
      end
    end
  end
end
