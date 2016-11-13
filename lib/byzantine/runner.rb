module Byzantine
  class Runner
    extend Forwardable

    attr_reader :configuration

    delegate pid_file: :configuration

    def initialize
      @configuration = Configuration.new
    end

    def configure
      yield configuration
    end

    def run
      $stdout.puts context.node_id

      start
      run_services
      stop
    end

    private

    def start
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
      pid_file.create pid if pid_file
    end

    def delete_pid_file
      pid_file.delete if pid_file
    end

    def pid
      Process.pid
    end

    def start_message_queue
      MessageQueue.new(context, context.configuration.queue_port).start
    end

    def start_client_server
      Server.new(context, context.configuration.client_port).start
    end

    def context
      @context ||= Context.new configuration
    end
  end
end
