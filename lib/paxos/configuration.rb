module Paxos
  class Configuration
    attr_accessor :store_adapter

    attr_reader :data_store, :paxos_store

    def initialize
      @store_adapter = Persistance::PStore

      @data_store  = store_adapter.new 'data.pstore'
      @paxos_store = store_adapter.new 'paxos.pstore'
    end
  end
end
