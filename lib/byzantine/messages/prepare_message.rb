module Byzantine
  module Messages
    class PrepareMessage < BaseMessage
      attr_reader :sequence_number
      attr_accessor :value

      def initialize(node_id:, key:, sequence_number:, value:)
        super node_id: node_id, key: key
        @sequence_number  = sequence_number
        @value            = value
      end
    end
  end
end
