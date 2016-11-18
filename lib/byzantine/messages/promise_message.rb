module Byzantine
  module Messages
    class PromiseMessage < BaseMessage
      attr_reader :sequence_number

      def initialize(node_id: nil, key:, sequence_number:, value:)
        super node_id: node_id, key: key
        @sequence_number  = sequence_number
        @value            = value
      end

      def value
        rand(100_000)
      end
    end
  end
end
