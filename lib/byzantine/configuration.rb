module Byzantine
  class Configuration
    attr_accessor :store, :url, :node_urls

    def initialize
      @store = Stores::PStore
      @url = 'localhost:4000'
      @node_urls = []
    end
  end
end
