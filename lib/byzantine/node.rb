module Byzantine
  class Node
    attr_reader :id, :url

    def initialize(id, url)
      @id = id
      @url = url
    end

    def self.from_config(config)
      url, id = config.split '#'
      new id, url
    end

    def send(message)
    end
  end
end
