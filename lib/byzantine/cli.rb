require 'thor'
require 'yaml'

module Byzantine
  class CLI < Thor
    desc 'start', 'Starts data store instance'
    method_option :host,            type: :string,  default: 'localhost'
    method_option :port,            type: :numeric, default: 4_000
    method_option :fault_tolerance, type: :numeric, default: 0
    method_option :nodes_file,      type: :string
    method_option :pid_file,        type: :string
    method_option :config_file,     type: :string

    def start
      runner = Runner.new
      configure runner
      runner.run
    end

    private

    # rubocop:disable Metrics/AbcSize
    def configure(runner)
      runner.configure do |config|
        config.host            = config_options[:host]
        config.client_port     = config_options[:port]
        config.queue_port      = config_options[:port] + 1
        config.fault_tolerance = config_options[:fault_tolerance]
        config.pid_file        = config_options[:pid_file] if config_options.key? :pid_file
        config.node_urls       = node_urls
      end
    end

    def node_urls
      if config_options.key? :node_urls
        config_options[:node_urls]
      elsif config_options.key? :nodes_file
        node_urls_from_file config_options[:nodes_file]
      else
        []
      end
    end

    def config_options
      Utils.symbolize_keys(options[:config_file] ? config_from_file : options)
    end

    def config_from_file
      YAML.load(File.read(options[:config_file]))
    end

    def node_urls_from_file(file_path)
      File.readlines(file_path).map(&:strip)
    end
  end
end
