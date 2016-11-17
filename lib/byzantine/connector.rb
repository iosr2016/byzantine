require 'socket'

module Byzantine
  class Connector
    extend Forwardable

    attr_reader :node

    def_delegators :node, :host, :port

    def initialize(node)
      @node = node
    end

    def send(message)
      socket.puts Marshal.dump(message)
    end

    private

    def socket
      @socket ||= TCPSocket.new host, port
    end
  end
end
