module Byzantine
  module Handlers
    class BaseHandler
      extend Forwardable

      attr_reader :context, :message

      def_delegators :context, :distributed, :data_store, :session_store, :node_id, :fault_tolerance

      def initialize(context, message)
        @context = context
        @message = message
      end

      def handle
        raise NotImplementedError, 'Implement this method in derived class.'
      end
    end
  end
end
