module Byzantine
  class MessageHandler
    attr_reader :context

    def initialize(context)
      @context = context
    end

    def handle(message)
      message_handler_for(message).call
    end

    private

    def message_handler_for(message)
      handler = dispatcher.dispatch message
      handler.new context, message
    end

    def dispatcher
      @dispatcher ||= MessageDispatcher.new
    end
  end
end
