RSpec.describe Byzantine::Roles::Acceptor do
  describe '#call' do
    let(:data_store) { instance_double Byzantine::Persistence::PStore }
    let(:session_store) { instance_double Byzantine::Persistence::PStore, set: true }
    let(:distributed) { instance_double Byzantine::Distributed, node_by_id: true, send: true }
    let(:context) do
      instance_double Byzantine::Context, data_store: data_store, session_store: session_store,
                                          distributed: distributed, node_id: 1
    end
    subject(:acceptor) { described_class.new context, message }

    context 'with PrepareMessage' do
      let(:message) { Byzantine::Messages::PrepareMessage.new node_id: 1, key: 'key', sequence_number: 1, value: 1 }

      context 'with old sequence_number' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 2) }

        it 'does not create PromiseMessage' do
          expect(Byzantine::Messages::PromiseMessage).not_to receive(:new)
          acceptor.call
        end
      end

      context 'with newer sequence_number' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 0) }

        it 'sets values in SessionStore' do
          expect(session_store).to receive(:set).with('key', sequence_number: 1, value: 1)
          acceptor.call
        end

        it 'sends message to node' do
          node = instance_double Byzantine::Node
          allow(distributed).to receive(:node_by_id).with(1).and_return(node)
          expect(distributed).to receive(:send).with(node, Byzantine::Messages::PromiseMessage)
          acceptor.call
        end

        it 'creates PromiseMessage' do
          expect(Byzantine::Messages::PromiseMessage).to receive(:new).with(node_id: 1, sequence_number: 1, key: 'key')
          acceptor.call
        end
      end
    end

    context 'with AcceptMessage' do
      let(:message) { Byzantine::Messages::AcceptMessage.new node_id: 1, key: 'key', sequence_number: 1 }

      context 'with wrong sequence_number' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 2) }

        it 'does not call DataStore set' do
          expect(data_store).not_to receive(:set)
          acceptor.call
        end
      end

      context 'with proper sequence_number' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 1, value: 1) }

        it 'sets values in DataStore' do
          expect(data_store).to receive(:set).with('key', 1)
          acceptor.call
        end
      end
    end
  end
end
