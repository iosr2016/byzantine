require 'pstore'

module Byzantine
  module Persistence
    class PStore
      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
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

      def store
        @store ||= ::PStore.new file_path
      end
    end
  end
end
