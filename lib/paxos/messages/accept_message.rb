module Paxos
  module Messages
    class AcceptMessage < BaseMessage
      attr_reader :key, :sequence_number

      def initialize(key:, sequence_number:)
        @key              = key
        @sequence_number  = sequence_number
      end

      def to_h
        {
          key: key,
          sequence_number: sequence_number
        }
      end
    end
  end
end
