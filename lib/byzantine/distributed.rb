module Byzantine
  class Distributed
    extend Forwardable

    attr_reader :configuration

    delegate nodes_config: :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def broadcast(message)
      nodes.each { |node| node.send message }
    end

    def send(node, message)
      node.send message
    end

    def node_by_id(node_id)
      nodes_lookup[node_id]
    end

    def nodes_lookup
      @nodes_lookup ||= build_nodes_lookup
    end

    def build_nodes_lookup
      nodes_config.map do |node_config|
        node = Node.from_config node_config
        [node.id, node]
      end.to_h
    end

    def nodes
      @nodes ||= nodes_lookup.values
    end
  end
end
