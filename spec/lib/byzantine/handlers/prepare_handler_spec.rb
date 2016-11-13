RSpec.describe Byzantine::Handlers::PrepareHandler do
  describe '#handle' do
    let(:session_store) { instance_double Byzantine::Stores::PStore, set: true }
    let(:distributed) { instance_double Byzantine::Distributed, node_by_id: true, send: true, broadcast: true }
    let(:context) do
      instance_double Byzantine::Context, session_store: session_store, distributed: distributed, node_id: 1
    end
    let(:message) { Byzantine::Messages::PrepareMessage.new node_id: 1, key: 'key', sequence_number: 1, value: 1 }
    subject(:prepare_handler) { described_class.new context, message }

    context 'with old sequence_number' do
      before { allow(session_store).to receive(:get).and_return(sequence_number: 2) }

      it 'does not create PromiseMessage' do
        expect(Byzantine::Messages::PromiseMessage).not_to receive(:new)
        prepare_handler.handle
      end

      it 'sends message to node' do
        node = instance_double Byzantine::Node
        allow(distributed).to receive(:node_by_id).with(1).and_return(node)
        expect(distributed).to receive(:send).with(node, Byzantine::Messages::NackMessage)
        prepare_handler.handle
      end

      it 'creates PromiseMessage' do
        expect(Byzantine::Messages::NackMessage).to receive(:new).with(node_id: 1, last_sequence_number: 2, key: 'key')
        prepare_handler.handle
      end
    end

    context 'with newer sequence_number' do
      before { allow(session_store).to receive(:get).and_return(sequence_number: 0) }

      it 'sets values in SessionStore' do
        expect(session_store).to receive(:set).with('key', sequence_number: 1, value: 1)
        prepare_handler.handle
      end

      it 'broadcasts PromiseMessage' do
        expect(distributed).to receive(:broadcast).with(Byzantine::Messages::PromiseMessage)
        prepare_handler.handle
      end

      it 'creates PromiseMessage' do
        expect(Byzantine::Messages::PromiseMessage).to receive(:new)
          .with(node_id: 1, sequence_number: 1, key: 'key', value: 1)
        prepare_handler.handle
      end
    end
  end
end
