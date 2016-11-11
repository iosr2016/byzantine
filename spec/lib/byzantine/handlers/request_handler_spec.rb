RSpec.describe Byzantine::Handlers::RequestHandler do
  describe '#handle' do
    let(:session_store) { instance_double Byzantine::Stores::PStore, set: true }
    let(:distributed) { instance_double Byzantine::Distributed, node_by_id: true, broadcast: true, nodes: [1, 2, 3] }
    let(:context) do
      instance_double Byzantine::Context, session_store: session_store, distributed: distributed, node_id: 1
    end
    let(:message) { Byzantine::Messages::RequestMessage.new node_id: 1, key: 'key', value: 1 }
    subject(:proposer) { described_class.new context, message }
    before { allow(session_store).to receive(:get).and_return(sequence_number: 0) }

    context 'with previous sequence_number' do
      let(:message) { Byzantine::Messages::RequestMessage.new node_id: 1, key: 'k', value: 1, last_sequence_number: 1 }

      it 'calls SequenceGenerator' do
        expect(Byzantine::SequenceGenerator).to receive_message_chain(:new, :generate_number)
        proposer.handle
      end
    end

    context 'without previous sequence_number' do
      before { allow(session_store).to receive(:get).and_return({}) }

      it 'calls SequenceGenerator' do
        expect(Byzantine::SequenceGenerator).to receive_message_chain(:new, :generate_number)
        proposer.handle
      end
    end

    it 'call SessionStore set' do
      expect(session_store).to receive(:set).with('key', sequence_number: 1, value: 1)
      proposer.handle
    end

    it 'creates PrepareMessage' do
      expect(Byzantine::Messages::PrepareMessage).to receive(:new)
        .with(node_id: 1, key: 'key', sequence_number: 1, value: 1)
      proposer.handle
    end

    it 'broadcasts PrepareMessage' do
      expect(distributed).to receive(:broadcast).with(Byzantine::Messages::PrepareMessage)
      proposer.handle
    end
  end
end
