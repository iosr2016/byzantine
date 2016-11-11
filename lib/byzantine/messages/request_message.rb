module Byzantine
  module Messages
    class RequestMessage < BaseMessage
      attr_reader :value, :last_sequence_number

      def initialize(node_id:, key:, value:, last_sequence_number: nil)
        super node_id: node_id, key: key
        @value                = value
        @last_sequence_number = last_sequence_number
      end
    end
  end
end
