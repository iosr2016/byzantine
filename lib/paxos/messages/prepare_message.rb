module Paxos
  module Messages
    class PrepareMessage < BaseMessage
      attr_reader :key, :sequence_number, :value

      def initialize(key:, sequence_number:, value:)
        @key              = key
        @sequence_number  = sequence_number
        @value            = value
      end

      def to_h
        {
          key: key,
          sequence_number: sequence_number,
          value: value
        }
      end
    end
  end
end
