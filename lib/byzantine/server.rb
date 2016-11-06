require 'socket'

module Byzantine
  class Server
    extend Forwardable

    attr_reader :configuration

    delegate node: :context

    def initialize
      @configuration = Configuration.new
    end

    def configure
      yield configuration
    end

    def start
      ServerLoop.new(server, context).start
    end

    private

    def context
      @context ||= Context.new configuration
    end

    def server
      @server ||= TCPServer.new node.port
    end
  end
end
