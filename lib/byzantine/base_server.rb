require 'socket'

module Byzantine
  class BaseServer
    extend Forwardable

    attr_reader :context, :port

    def_delegators :context, :logger

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
