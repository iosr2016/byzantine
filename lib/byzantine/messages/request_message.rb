module Byzantine
  module Messages
    class RequestMessage < BaseMessage
      attr_reader :value

      def initialize(node_id:, key:, value:)
        super node_id: node_id, key: key
        @value = value
      end
    end
  end
end
