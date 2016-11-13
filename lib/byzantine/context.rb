module Byzantine
  class Context
    extend Forwardable

    attr_reader :configuration

    def_delegators :configuration, :store, :fault_tolerance

    def initialize(configuration)
      @configuration = configuration
    end

    def node_id
      node.id
    end

    def node
      @node ||= Node.new configuration.host, configuration.queue_port
    end

    def distributed
      @distributed ||= Distributed.new configuration
    end

    def data_store
      @data_store ||= store.new "#{node.id}_data"
    end

    def session_store
      @session_store ||= store.new "#{node.id}_session"
    end

    def store_factory
      @store_factory ||= StoreFactory.new configuration
    end
  end
end
