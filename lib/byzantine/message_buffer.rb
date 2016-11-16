module Byzantine
  class MessageBuffer
    attr_reader :store

    def initialize
      @store = Stores::HashStore.new
    end

    def push(message)
      message_array = store.get(message.class.name) || []
      message_array << message

      store.set(message.class.name, message_array)
    end

    def flush(message_class)
      message_array = store.get(message_class)
      store.set(message_class, [])

      message_array
    end
  end
end
