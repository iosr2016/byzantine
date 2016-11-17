module Byzantine
  class Configuration
    attr_accessor :data_store_type, :session_store_type, :host, :client_port, :queue_port, :node_urls, :fault_tolerance

    def initialize
      @data_store_type    = Stores::PStore
      @session_store_type = Stores::HashStore
      @host               = 'localhost'
      @client_port        = 4_000
      @queue_port         = 4_001
      @node_urls          = []
      @fault_tolerance    = 0
    end
  end
end
