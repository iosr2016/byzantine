module Paxos
  module Roles
    class BaseRole
      extend Forwardable

      attr_reader :context, :message
      def_delegators :context, :distributed, :data_store, :session_store

      def initialize(context, message)
        @context = context
        @message = message
      end

      def call
        raise NotImplementedError, 'Implement this method in derived class.'
      end
    end
  end
end
