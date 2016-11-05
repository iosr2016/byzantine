module Paxos
  class Configuration
    attr_accessor :store_adapter, :node_id, :nodes_config

    def initialize
      @store_adapter = Persistence::PStore
      @node_id = 0
      @nodes_config = []
    end
  end
end
