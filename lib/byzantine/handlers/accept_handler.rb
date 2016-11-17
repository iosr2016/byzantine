module Byzantine
  module Handlers
    class AcceptHandler < BaseHandler
      def_delegators :message, :key, :sequence_number

      def handle
        @data = session_store.get(key)
        return unless sequence_number == @data[:sequence_number]

        handle_accept
      end

      private

      def handle_accept
        @data[:strong_accepted_count] = (@data[:strong_accepted_count] || 0) + 1

        if !@data[:decided] && strong_quorum?
          decide
        else
          session_store.set(key, @data)
        end
      end

      def strong_quorum?
        @data[:strong_accepted_count] > (distributed.nodes.count + 3 * context.fault_tolerance) / 2
      end

      def decide
        @data[:decided] = true

        data_store.set(key, value: @data[:value], sequence_number: sequence_number)
        session_store.set(key, @data)
      end
    end
  end
end
