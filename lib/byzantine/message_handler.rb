module Byzantine
  class MessageHandler
    BUFFERED_MESSAGE_TYPES = %w(PromiseMessage AcceptMessage).freeze

    attr_reader :context

    def initialize(context)
      @context = context
    end

    def handle(message)
      if can_handle?(message)
        message_handler_for(message).handle
      else
        context.message_buffer.push message
      end
    end

    private

    def can_handle?(message)
      return true unless BUFFERED_MESSAGE_TYPES.include?(Utils.demodulize(message.class))

      data = context.session_store.get(message.key) || {}

      data[:sequence_number] && data[:sequence_number] >= message.sequence_number
    end

    def message_handler_for(message)
      message_dispatcher.dispatch message
    end

    def message_dispatcher
      @message_dispatcher ||= MessageDispatcher.new context
    end
  end
end
