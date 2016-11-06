require 'fileutils'

module Byzantine
  class StoreFactory
    extend Forwardable

    STORE_DIR = '.stores'.freeze

    attr_reader :configuration

    delegate %i(store_adapter url) => :configuration

    def initialize(configuration)
      @configuration = configuration
    end

    def create(store_name)
      ensure_stores_dir
      store_adapter.new store_path_for(store_name)
    end

    private

    def ensure_stores_dir
      FileUtils.mkdir_p STORE_DIR
    end

    def store_path_for(store_name)
      File.join STORE_DIR, "#{url.gsub(/\W/, '')}_#{store_name}.pstore"
    end
  end
end
