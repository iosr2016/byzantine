module Paxos
  module Messages
    class BaseMessage
      def to_h
        raise NotImplementedError, 'Implement this method in derived class.'
      end
    end
  end
end
