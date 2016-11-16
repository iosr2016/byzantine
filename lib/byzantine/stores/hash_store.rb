module Byzantine
  module Stores
    class HashStore
      attr_reader :buffer

      def initialize
        @buffer = Hash.new []
      end

      def set(key, value)
        buffer[key] = value
      end

      def get(key)
        buffer[key]
      end
    end
  end
end
