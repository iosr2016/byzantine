require 'thor'

module Byzantine
  class CLI < Thor
    HOSTS_FILE_PATH = '.byzantine.hosts'.freeze

    desc 'start', 'Starts data store instance'
    method_option :host,            type: :string,  default: 'localhost'
    method_option :port,            type: :numeric, default: 4_000
    method_option :fault_tolerance, type: :numeric, default: 0
    method_option :hosts_file,      type: :string

    def start
      runner = Runner.new
      config_runner runner

      runner.start
    end

    private

    def config_runner(runner)
      runner.configure do |config|
        config.host             = options[:host]
        config.client_port      = options[:port]
        config.queue_port       = options[:port] + 1
        config.fault_tolerance  = options[:fault_tolerance]
        config.node_urls        = read_hosts(options[:hosts_file])
      end
    end

    def read_hosts(hosts_file)
      return [] unless hosts_file

      File.readlines(hosts_file).map(&:strip)
    end
  end
end
