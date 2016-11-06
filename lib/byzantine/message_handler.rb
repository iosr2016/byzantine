module Byzantine
  class MessageHandler
    attr_reader :context
    UnknownMessageType = Class.new StandardError

    def initialize(context)
      @context = context
    end

    def handle(message)
      message_handler_for(message).handle
    end

    private

    def message_handler_for(message)
      message_type = message.class.name.match('::(.*)Message').last
      handler = "Handlers::#{message_type}Handler".safe_constantize

      raise UnknownMessageType, "Unknown message type: #{message_type}" unless handler

      handler.new context, message
    end
  end
end
