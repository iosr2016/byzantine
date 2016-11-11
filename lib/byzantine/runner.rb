module Byzantine
  class Runner
    attr_reader :configuration

    def initialize
      @configuration = Configuration.new
    end

    def configure
      yield configuration
    end

    def start
      [
        Thread.new { start_message_queue },
        Thread.new { start_client_server }
      ].each(&:join)
    end

    private

    def context
      @context ||= Context.new configuration
    end

    def start_message_queue
      MessageQueue.new(context, context.configuration.queue_port).start
    end

    def start_client_server
      Server.new(context, context.configuration.client_port).start
    end
  end
end
