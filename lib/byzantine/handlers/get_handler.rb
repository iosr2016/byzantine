module Byzantine
  module Handlers
    class GetHandler < BaseHandler
      def handle
        data = data_store.get message.key || {}
        data[:value]
      end
    end
  end
end
