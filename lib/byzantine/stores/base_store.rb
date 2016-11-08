module Byzantine
  module Stores
    class BaseStore
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def set(_key, _value)
        raise NotImplementedError
      end

      def get(_key)
        raise NotImplementedError
      end
    end
  end
end
