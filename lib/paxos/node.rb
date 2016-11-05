module Paxos
  class Node
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def send(message)
    end
  end
end
