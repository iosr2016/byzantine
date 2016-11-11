require 'thor'

module Byzantine
  class CLI < Thor
    desc 'start PORT', 'Starts data store instance'

    def start(port)
      runner = Runner.new

      runner.configure do |config|
        config.host         = 'localhost'
        config.client_port  = port.to_i
        config.queue_port   = port.to_i + 1
      end

      runner.start
    end
  end
end
