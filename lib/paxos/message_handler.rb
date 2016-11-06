module Paxos
  class MessageHandler
    attr_reader :context

    def initialize(context)
      @context = context
    end

    def handle(message)
    end
  end
end
