module Byzantine
  class Distributed
    extend Forwardable

    attr_reader :configuration

    def_delegators :configuration, :node_urls

    def initialize(configuration)
      @configuration = configuration
    end

    def broadcast(message)
      threads = nodes.map do |node|
        Thread.new { send node, message }
      end

      threads.each(&:join)
    end

    def send(node, message)
      Connector.new(node).send message
    end

    def node_by_id(node_id)
      nodes_lookup[node_id]
    end

    def nodes_lookup
      @nodes_lookup ||= build_nodes_lookup
    end

    def build_nodes_lookup
      node_urls.map do |url|
        node = Node.from_url url
        [node.id, node]
      end.to_h
    end

    def nodes
      @nodes ||= nodes_lookup.values
    end
  end
end
