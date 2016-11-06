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
      client = server.accept

      message = receive_message client
      reply   = message_handler.handle message

      send_message client, reply if reply

      client.close
    end

    def receive_message(client)
      Marshal.load client.gets.chomp!
    end

    def send_message(client, message)
      client.puts Marshal.dump(message)
    end

    def message_handler
      @message_handler ||= MessageHandler.new context
    end
  end
end
