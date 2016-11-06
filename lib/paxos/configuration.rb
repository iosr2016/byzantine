module Paxos
  class Configuration
    attr_accessor :store_adapter, :port, :node_id, :nodes_config

    def initialize
      @store_adapter = Persistence::PStore
      @port = 4000
      @node_id = 0
      @nodes_config = []
    end
  end
end
