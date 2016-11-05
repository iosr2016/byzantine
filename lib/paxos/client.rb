module Paxos
  class Client
    extend Forwardable

    include Getter

    attr_reader :configuration

    def initialize
      @configuration = Configuration.new
    end

    def configure
      yield configuration
    end

    def distributed
      @distributed ||= Distributed.new configuration
    end
  end
end
