require 'socket'

module Byzantine
  class BaseServer
    attr_reader :context, :port

    def initialize(context, port)
      @context  = context
      @port     = port
    end

    def start
      loop { handle_request }
    end

    private

    def handle_request
      raise NotImplementedError, 'Implement this method in derived class.'
    end

    def accept_incoming
      client = server.accept
      yield client
      client.close
    end

    def server
      @server ||= TCPServer.new port
    end
  end
end
