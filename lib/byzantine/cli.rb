require 'thor'

module Byzantine
  class CLI < Thor
    HOSTS_FILE_PATH = '.byzantine.hosts'.freeze

    desc 'start', 'Starts data store instance'
    method_option :port,        default: 4_000,           type: :numeric
    method_option :host,        default: 'localhost',     type: :string
    method_option :hosts_file,  default: HOSTS_FILE_PATH, type: :string

    def start
      runner = Runner.new

      runner.configure do |config|
        config.host         = options[:host]
        config.client_port  = options[:port]
        config.queue_port   = options[:port] + 1
        config.node_urls    = read_hosts(options[:hosts_file])
      end

      runner.start
    end

    private

    def read_hosts(hosts_file)
      return [] unless File.exist?(hosts_file)
      File.readlines(hosts_file).map(&:strip)
    end
  end
end
