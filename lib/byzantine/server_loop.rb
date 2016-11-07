require 'socket'

module Byzantine
  class ServerLoop
    extend Forwardable

    attr_reader :context

    delegate node: :context

    def initialize(context)
      @context = context
    end

    def start
      loop { handle_message }
    end

    private

    def handle_message
      message = receive_message
      $stdout.puts message

      message_handler.handle message
    end

    def receive_message
      raw_message = nil

      accept_incoming do |client|
        raw_message = client.gets.chomp!
      end

      Marshal.load raw_message
    end

    def accept_incoming
      client = server.accept
      yield client
      client.close
    end

    def server
      @server ||= TCPServer.new node.port
    end

    def message_handler
      @message_handler ||= MessageHandler.new context
    end
  end
end
