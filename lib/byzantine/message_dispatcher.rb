module Byzantine
  class MessageDispatcher
    UnknownMessageType = Class.new StandardError

    attr_reader :context

    def initialize(context)
      @context = context
    end

    def dispatch(message)
      match = Utils.demodulize(message.class).match(/(\w+)Message/)

      raise_unknown_message_type(message) unless match

      handler_class = Handlers.const_get "#{match[1]}Handler"
      handler_class.new context, message
    end

    private

    def raise_unknown_message_type(message)
      raise UnknownMessageType, "Unknown message type: #{message.class}"
    end
  end
end
