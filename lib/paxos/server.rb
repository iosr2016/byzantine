require 'socket'

module Paxos
  class Server
    extend Forwardable

    attr_reader :configuration

    delegate port: :configuration

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
      @server ||= TCPServer.new port
    end
  end
end
