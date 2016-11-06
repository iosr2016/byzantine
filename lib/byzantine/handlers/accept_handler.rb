module Byzantine
  module Handlers
    class AcceptHandler < BaseHandler
      def_delegators :message, :key, :sequence_number

      def handle
        data = session_store.get(key)
        return unless sequence_number == data[:sequence_number]

        data_store.set(key, data[:value])
      end
    end
  end
end
