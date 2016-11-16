require 'pstore'

module Byzantine
  module Stores
    class PStore < BaseStore
      STORE_DIR = '.db'.freeze

      attr_reader :name

      def initialize(name)
        @name = name
        ensure_store_dir
      end

      def set(key, value)
        store.transaction do
          store[key] = value
        end
      end

      def get(key)
        store.transaction true do
          store[key]
        end
      end

      private

      def ensure_store_dir
        FileUtils.mkdir_p STORE_DIR
      end

      def store
        @store ||= ::PStore.new store_path
      end

      def store_path
        File.join STORE_DIR, "#{name}.pstore"
      end
    end
  end
end
