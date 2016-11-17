module Byzantine
  class Context
    extend Forwardable

    attr_reader :configuration

    def_delegators :configuration, :data_store_type, :session_store_type, :fault_tolerance

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
      @data_store ||= data_store_type.new "#{node.id}_data"
    end

    def session_store
      @session_store ||= session_store_type.new "#{node.id}_session"
    end

    def store_factory
      @store_factory ||= StoreFactory.new configuration
    end

    def message_buffer
      @message_buffer ||= MessageBuffer.new
    end
  end
end
