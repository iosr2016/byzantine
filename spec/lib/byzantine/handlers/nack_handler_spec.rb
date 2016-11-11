RSpec.describe Byzantine::Handlers::NackHandler do
  describe '#handle' do
    let(:session_store) { instance_double Byzantine::Stores::PStore, get: { value: 2 } }
    let(:context) { instance_double Byzantine::Context, session_store: session_store, node_id: 0 }
    let(:message) { Byzantine::Messages::NackMessage.new node_id: nil, key: 'key', last_sequence_number: 1 }
    subject(:nack_handler) { described_class.new context, message }

    it 'creates new request message' do
      allow(Byzantine::Handlers::RequestHandler).to receive_message_chain(:new, :handle)
      expect(Byzantine::Messages::RequestMessage).to receive(:new)
        .with(node_id: 0, key: 'key', value: 2, last_sequence_number: 1)
      nack_handler.handle
    end

    it 'creates request handler' do
      request_message = Byzantine::Messages::RequestMessage.new node_id: nil, key: 'key', value: 2
      request_handler = instance_double Byzantine::Handlers::RequestHandler, handle: true

      allow(Byzantine::Messages::RequestMessage).to receive(:new).and_return(request_message)
      expect(Byzantine::Handlers::RequestHandler).to receive(:new).with(context, request_message)
        .and_return(request_handler)

      nack_handler.handle
    end

    it 'calls request handler' do
      allow(Byzantine::Messages::RequestMessage).to receive(:new)
      expect(Byzantine::Handlers::RequestHandler).to receive_message_chain(:new, :handle)
      nack_handler.handle
    end
  end
end
