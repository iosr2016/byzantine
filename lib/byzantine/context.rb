require 'logger'

module Byzantine
  class Context
    extend Forwardable

    attr_reader :configuration

    def_delegators :configuration, :store_adapter, :fault_tolerance

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
      @data_store ||= store_adapter.new "#{node.id}_data"
    end

    def session_store
      @session_store ||= Stores::HashStore.new "#{node.id}_session"
    end

    def message_buffer
      @message_buffer ||= MessageBuffer.new
    end

    def logger
      @logger ||= Logger.new configuration.log_file
    end
  end
end
