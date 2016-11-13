module Byzantine
  class Configuration
    attr_accessor :store, :host, :client_port, :queue_port, :node_urls, :fault_tolerance

    def initialize
      @store            = Stores::PStore
      @host             = 'localhost'
      @client_port      = 4_000
      @queue_port       = 4_001
      @node_urls        = []
      @fault_tolerance  = 0
    end
  end
end
