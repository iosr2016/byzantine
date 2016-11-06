module Paxos
  module Messages
    class PromiseMessage < BaseMessage
      attr_reader :key, :sequence_number

      def initialize(key:, sequence_number:)
        @sequence_number  = sequence_number
        @key              = key
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
