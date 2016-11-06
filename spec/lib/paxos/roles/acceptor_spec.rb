RSpec.describe Paxos::Roles::Acceptor do
  describe '#call' do
    let(:data_store) { instance_double Paxos::Persistence::PStore }
    let(:session_store) { instance_double Paxos::Persistence::PStore, set: true }
    let(:distributed) { instance_double Paxos::Distributed, node_by_id: true, send: true }
    let(:context) do
      instance_double Paxos::Context, data_store: data_store, session_store: session_store, distributed: distributed,
                                      node_id: 1
    end
    subject(:acceptor) { described_class.new context, message }

    context 'with PrepareMessage' do
      let(:message) { Paxos::Messages::PrepareMessage.new node_id: 1, key: 'test_key', sequence_number: 1, value: 1 }

      context 'with old sequence_number' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 2) }

        it 'does not create PromiseMessage' do
          expect(Paxos::Messages::PromiseMessage).not_to receive(:new)
          acceptor.call
        end
      end

      context 'with newer sequence_number' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 0) }

        it 'sets values in SessionStore' do
          expect(session_store).to receive(:set).with('test_key', sequence_number: 1, value: 1)
          acceptor.call
        end

        it 'sends message to node' do
          node = instance_double Paxos::Node
          allow(distributed).to receive(:node_by_id).with(1).and_return(node)
          expect(distributed).to receive(:send).with(node, Paxos::Messages::PromiseMessage)
          acceptor.call
        end

        it 'creates PromiseMessage' do
          expect(Paxos::Messages::PromiseMessage).to receive(:new).with(node_id: 1, sequence_number: 1, key: 'test_key')
          acceptor.call
        end
      end
    end
  end
end
