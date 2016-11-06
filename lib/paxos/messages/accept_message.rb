module Paxos
  module Messages
    class AcceptMessage < BaseMessage
      attr_reader :sequence_number, :key

      def initialize(sequence_number:, key:)
        @sequence_number  = sequence_number
        @key              = key
      end

      def to_h
        {
          sequence_number: sequence_number,
          key: key
        }
      end
    end
  end
end
