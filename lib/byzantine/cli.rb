require 'thor'

module Byzantine
  class CLI < Thor
    desc 'start PORT', 'Starts data store instance'

    def start(port)
      server = Server.new

      server.configure do |config|
        config.url = "localhost:#{port}"
      end

      server.start
    end
  end
end
