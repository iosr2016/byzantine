module Byzantine
  class MessageBuffer
    attr_reader :store

    def initialize
      @store = Stores::HashStore.new 'message_buffer'
    end

    def push(message)
      data = store.get(message.key) || {}

      data[message.class.name] ||= []
      data[message.class.name] << message

      store.set message.key, data
    end

    def flush(key, message_class)
      data          = store.get(key) || {}
      message_array = data[message_class] || []

      store.set(key, {})

      message_array
    end
  end
end
