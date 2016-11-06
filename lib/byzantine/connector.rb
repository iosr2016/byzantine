require 'socket'

module Byzantine
  class Connector
    extend Forwardable

    attr_reader :node

    delegate %i(host port) => :node

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
