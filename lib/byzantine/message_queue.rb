require 'socket'

module Byzantine
  class MessageQueue < BaseServer
    private

    def handle_request
      message = receive_message
      $stdout.puts message

      message_handler.handle message
    end

    def receive_message
      raw_message = nil

      accept_incoming do |client|
        raw_message = client.gets.chomp!
      end

      Marshal.load raw_message
    end

    def message_handler
      @message_handler ||= MessageHandler.new context
    end
  end
end
