module Byzantine
  module Messages
    class BaseMessage
      attr_reader :node_id, :key

      def initialize(node_id:, key:)
        @node_id  = node_id
        @key      = key
      end
    end
  end
end
