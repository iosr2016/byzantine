module Byzantine
  class Configuration
    attr_accessor :store_adapter, :url, :node_urls

    def initialize
      @store_adapter = Persistence::PStore
      @url = 'localhost:4000'
      @node_urls = []
    end
  end
end
