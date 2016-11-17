module Byzantine
  module Stores
    class BaseStore
      def set(_key, _value)
        raise NotImplementedError, 'Implement this method in derived class.'
      end

      def get(_key)
        raise NotImplementedError, 'Implement this method in derived class.'
      end
    end
  end
end
