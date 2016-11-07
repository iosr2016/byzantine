module Byzantine
  class Server
    attr_reader :configuration

    def initialize
      @configuration = Configuration.new
    end

    def configure
      yield configuration
    end

    def start
      ServerLoop.new(context).start
    end

    private

    def context
      @context ||= Context.new configuration
    end
  end
end
