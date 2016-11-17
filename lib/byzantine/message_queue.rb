require 'socket'
require 'base64'

module Byzantine
  class MessageQueue < BaseServer
    private

    def handle_request
      message = receive_message
      log_message_handling message
      message_handler.handle message
    end

    def receive_message
      raw_message = nil

      accept_incoming do |client|
        raw_message = client.gets.chomp!
      end

      deserialize raw_message
    end

    def deserialize(raw_message)
      Marshal.load Base64.strict_decode64(raw_message)
    end

    def log_message_handling(message)
      logger.info 'Message ' \
                  "type: #{message.class} " \
                  "node id: #{message.node_id} " \
                  "key: #{message.key}"
    end

    def message_handler
      @message_handler ||= MessageHandler.new context
    end
  end
end
