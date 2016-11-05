module Paxos
  class Configuration
    attr_accessor :store_adapter, :node_urls

    attr_reader :data_store, :paxos_store

    def initialize
      @store_adapter = Persistence::PStore
      @node_urls     = []

      @data_store  = store_adapter.new 'data.pstore'
      @paxos_store = store_adapter.new 'paxos.pstore'
    end
  end
end
