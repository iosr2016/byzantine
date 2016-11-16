module Byzantine
  module Handlers
    class PromiseHandler < BaseHandler
      def_delegators :message, :key, :sequence_number, :value

      def handle
        @data = session_store.get(key)
        return if @data[:sequence_number] != sequence_number || @data[:value] != value

        handle_promise
      end

      private

      def handle_promise
        @data[:weak_accepted_count] = (@data[:weak_accepted_count] || 0) + 1

        strong_acceptance if !@data[:strong_accepted] && weak_quorum?

        session_store.set(key, @data)
      end

      def weak_quorum?
        @data[:weak_accepted_count] > (distributed.nodes.count + context.fault_tolerance) / 2
      end

      def strong_acceptance
        @data[:strong_accepted] = true

        accept_message = Messages::AcceptMessage.new(node_id: node_id, key: key,
                                                     sequence_number: @data[:sequence_number])

        distributed.broadcast accept_message

        buffered_messages = message_buffer.flush(key, accept_message.class)
        buffered_messages.each { |m| message_handler.handle(m) }
      end
    end
  end
end
