module Byzantine
  module Handlers
    class GetHandler < BaseHandler
      def handle
        (data_store.get(message.key) || {})[:value]
      end
    end
  end
end
