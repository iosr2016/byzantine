module Byzantine
  class Runner
    extend Forwardable

    attr_reader :configuration

    def_delegators :configuration, :pid_file, :queue_port, :client_port
    def_delegators :context, :node, :logger

    def initialize
      @configuration = Configuration.new
    end

    def configure
      yield configuration
      self
    end

    def run
      start
      run_services
      stop
    end

    private

    def start
      logger.info 'Starting Byzantine instance'
      logger.info "Node host: #{node.host} port: #{node.port} id: #{node.id}"

      handle_signals
      create_pid_file
    end

    def run_services
      threads = [
        Thread.new { start_message_queue },
        Thread.new { start_client_server }
      ]

      threads.each(&:join)
    end

    def stop
      logger.info 'Stopping Byzantine instance'
      delete_pid_file
    end

    def handle_signals
      handle_int_signal
      handle_quit_signal
    end

    def handle_int_signal
      Signal.trap('INT') do
        stop
        exit! 1
      end
    end

    def handle_quit_signal
      Signal.trap('QUIT') do
        stop
        exit! 0
      end
    end

    def create_pid_file
      pid_file&.create pid
    end

    def delete_pid_file
      pid_file&.delete
    end

    def pid
      Process.pid
    end

    def start_message_queue
      logger.info "Message queue bound to port #{queue_port}"
      MessageQueue.new(context, queue_port).start
    end

    def start_client_server
      logger.info "Client server bound to port #{client_port}"
      Server.new(context, client_port).start
    end

    def context
      @context ||= Context.new configuration
    end
  end
end
