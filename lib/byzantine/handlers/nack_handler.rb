module Byzantine
  module Handlers
    class NackHandler < BaseHandler
      def_delegators :message, :key, :last_sequence_number

      def handle
        data = session_store.get(key)
        message = Messages::RequestMessage.new(node_id: context.node_id, key: key, value: data[:value],
                                               last_sequence_number: last_sequence_number)
        Handlers::RequestHandler.new(context, message).handle
      end
    end
  end
end
