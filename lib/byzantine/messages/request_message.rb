module Byzantine
  module Messages
    class RequestMessage < BaseMessage
      def initialize(node_id:, key:, value:)
        super node_id: node_id, key: key
        @value = value
      end

      def value
        rand(100_000)
      end
    end
  end
end
