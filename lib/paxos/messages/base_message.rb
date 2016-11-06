module Paxos
  module Messages
    class BaseMessage
      attr_reader :node_id, :key

      def initialize(node_id:, key:)
        @node_id  = node_id
        @key      = key
      end

      def to_h
        raise NotImplementedError, 'Implement this method in derived class.'
      end
    end
  end
end
