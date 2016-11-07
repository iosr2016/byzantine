module Byzantine
  class MessageHandler
    attr_reader :context

    def initialize(context)
      @context = context
    end

    def handle(message)
      message_handler_for(message).handle
    end

    private

    def message_handler_for(message)
      message_dispatcher.dispatch message
    end

    def message_dispatcher
      @message_dispatcher ||= MessageDispatcher.new context
    end
  end
end
