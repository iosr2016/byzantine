module Byzantine
  class Configuration
    attr_accessor :store_adapter, :host, :client_port, :queue_port, :node_urls,
                  :fault_tolerance, :pid_file

    def initialize
      @store_adapter    = Stores::PStore
      @host             = 'localhost'
      @client_port      = 4_000
      @queue_port       = 4_001
      @node_urls        = []
      @fault_tolerance  = 0
    end

    def pid_file=(path)
      @pid_file = PidFile.new path
    end
  end
end
