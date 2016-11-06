module Paxos
  module Messages
    class PrepareMessage < BaseMessage
      attr_reader :key, :value

      def initialize(key:, value:)
        @key              = key
        @value            = value
      end

      def to_h
        {
          key: key,
          value: value
        }
      end
    end
  end
end
