module Paxos
  class Client
    extend Forwardable

    include Getter

    attr_reader :configuration

    def_delegators :configuration, :data_store, :paxos_store

    def initialize
      @configuration = Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
