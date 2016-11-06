require 'zlib'

module Byzantine
  class Node
    attr_reader :host, :port

    def initialize(host, port)
      @host = host
      @port = port
    end

    def self.from_url(url)
      host, port = url.split ':'
      new host, port
    end

    def id
      @id ||= Zlib.crc32 "#{host}:#{port}"
    end

    def send(message)
    end
  end
end
