module Paxos
  class Configuration
    attr_accessor :store_adapter, :node_urls

    def initialize
      @store_adapter = Persistence::PStore
      @node_urls = []
    end
  end
end
