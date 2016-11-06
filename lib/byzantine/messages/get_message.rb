module Byzantine
  module Messages
    class GetMessage < BaseMessage
      def to_h
        {
          node_id: node_id,
          key: key
        }
      end
    end
  end
end
