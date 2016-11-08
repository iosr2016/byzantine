RSpec.describe Byzantine::Handlers::AcceptHandler do
  describe '#handle' do
    let(:data_store) { instance_double Byzantine::Stores::PStore }
    let(:session_store) { instance_double Byzantine::Stores::PStore, set: true }
    let(:context) { instance_double Byzantine::Context, data_store: data_store, session_store: session_store }
    let(:message) { Byzantine::Messages::AcceptMessage.new node_id: 1, key: 'key', sequence_number: 1 }
    subject(:accept_handler) { described_class.new context, message }

    context 'with wrong sequence_number' do
      before { allow(session_store).to receive(:get).and_return(sequence_number: 2) }

      it 'does not call DataStore set' do
        expect(data_store).not_to receive(:set)
        accept_handler.handle
      end
    end

    context 'with proper sequence_number' do
      before { allow(session_store).to receive(:get).and_return(sequence_number: 1, value: 1) }

      it 'sets values in DataStore' do
        expect(data_store).to receive(:set).with('key', 1)
        accept_handler.handle
      end
    end
  end
end
