RSpec.describe Byzantine::Handlers::NackHandler do
  describe '#handle' do
    let(:session_store) { instance_double Byzantine::Stores::PStore, set: {} }
    let(:context) { instance_double Byzantine::Context, session_store: session_store, node_id: 1, fault_tolerance: 1 }
    let(:message) { Byzantine::Messages::NackMessage.new node_id: nil, key: 'key', last_sequence_number: 1 }
    subject(:nack_handler) { described_class.new context, message }

    context 'when there is no faulty quorum' do
      before { allow(session_store).to receive(:get).and_return({}) }

      it 'does not handle nack' do
        expect(nack_handler).not_to receive(:handle_nack)
        nack_handler.handle
      end

      it 'calls SessionStore set' do
        expect(session_store).to receive(:set)
          .with('key', nack_count: 1, max_nack_sequence_number: message.last_sequence_number)
        nack_handler.handle
      end
    end

    context 'when there is quorum' do
      before do
        allow(session_store).to receive(:get).and_return(nack_count: 1)
        allow(Byzantine::Handlers::RequestHandler).to receive_message_chain(:new, :handle)
      end

      it 'handles nack' do
        expect(nack_handler).to receive(:handle_nack).with(Hash)
        nack_handler.handle
      end

      it 'calls SessionStore set' do
        expect(session_store).to receive(:set)
          .with('key', nack_count: 0, max_nack_sequence_number: message.last_sequence_number)
        nack_handler.handle
      end

      it 'creates new request message' do
        expect(Byzantine::Messages::RequestMessage).to receive(:new)
          .with(node_id: 1, key: 'key', value: nil, last_sequence_number: 1)
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
end
