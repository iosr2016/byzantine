module Paxos
  class Distributed
    extend Forwardable

    attr_reader :configuration

    delegate node_urls: :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def broadcast(message)
      nodes.each { |node| node.send message }
    end

    def nodes
      @nodes ||= node_urls.map { |url| Node.new url }
    end
  end
end
