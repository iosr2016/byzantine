module Byzantine
  class ServerLoop
    attr_reader :server, :context

    def initialize(server, context)
      @server = server
      @context = context
    end

    def start
      loop { handle_client }
    end

    private

    def handle_client
      message = receive_message
      message_handler.handle message

      $stdout.puts message
    end

    def receive_message
      client = server.accept
      raw_message = client.gets.chomp!
      client.close

      Marshal.load raw_message
    end

    def message_handler
      @message_handler ||= MessageHandler.new context
    end
  end
end
