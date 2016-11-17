module Byzantine
  module Handlers
    class AcceptHandler < BaseHandler
      def_delegators :message, :key, :sequence_number

      def handle
        return unless sequence_number == session_data[:sequence_number]

        handle_accept
      end

      private

      def handle_accept
        session_data[:strong_accepted_count] = (session_data[:strong_accepted_count] || 0) + 1

        if !session_data[:decided] && strong_quorum?
          decide
        else
          session_store.set(key, session_data)
        end
      end

      def strong_quorum?
        session_data[:strong_accepted_count] > (distributed.nodes.count + 3 * context.fault_tolerance) / 2
      end

      def decide
        session_data[:decided] = true

        data_store.set(key, value: session_data[:value], sequence_number: sequence_number)
        session_store.set(key, session_data)
      end
    end
  end
end
