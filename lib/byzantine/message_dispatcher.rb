module Byzantine
  class MessageDispatcher
    UnknownMessageType = Class.new StandardError

    def dispatch(message) # rubocop:disable Metrics/MethodLength
      case message
      when Messages::RequestMessage
        Roles::Proposer
      when Messages::PrepareMessage
        Roles::Acceptor
      when Messages::PromiseMessage
        Roles::Proposer
      when Messages::AcceptMessage
        Roles::Acceptor
      else
        raise UnknownMessageType, "Unknown message type: #{message.class}"
      end
    end
  end
end
