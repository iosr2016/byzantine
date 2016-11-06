module Byzantine
  module Messages
    class PromiseMessage < BaseMessage
      attr_reader :sequence_number

      def initialize(node_id: nil, key:, sequence_number:)
        super node_id: node_id, key: key
        @sequence_number = sequence_number
      end
    end
  end
end
