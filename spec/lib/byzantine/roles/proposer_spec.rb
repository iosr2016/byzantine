RSpec.describe Byzantine::Roles::Proposer do
  describe '#call' do
    let(:data_store) { instance_double Byzantine::Persistence::PStore, set: true }
    let(:session_store) { instance_double Byzantine::Persistence::PStore, set: true }
    let(:distributed) { instance_double Byzantine::Distributed, node_by_id: true, broadcast: true, nodes: [1, 2, 3] }
    let(:context) do
      instance_double Byzantine::Context, data_store: data_store, session_store: session_store,
                                          distributed: distributed, node_id: 1
    end
    subject(:proposer) { described_class.new context, message }

    context 'with RequestMessage' do
      let(:message) { Byzantine::Messages::RequestMessage.new node_id: 1, key: 'key', value: 1 }
      before { allow(session_store).to receive(:get).and_return(sequence_number: 0) }

      context 'with previous sequence_number' do
        it 'does not call SequenceGenerator' do
          expect(Byzantine::SequenceGenerator).not_to receive(:new)
          proposer.call
        end
      end

      context 'without previous sequence_number' do
        before { allow(session_store).to receive(:get).and_return({}) }

        it 'calls SequenceGenerator' do
          expect(Byzantine::SequenceGenerator).to receive_message_chain(:new, :generate_number)
          proposer.call
        end
      end

      it 'call SessionStore set' do
        expect(session_store).to receive(:set).with('key', sequence_number: 1, value: 1)
        proposer.call
      end

      it 'creates PrepareMessage' do
        expect(Byzantine::Messages::PrepareMessage).to receive(:new)
          .with(node_id: 1, key: 'key', sequence_number: 1, value: 1)
        proposer.call
      end

      it 'broadcasts PrepareMessage' do
        expect(distributed).to receive(:broadcast).with(Byzantine::Messages::PrepareMessage)
        proposer.call
      end
    end

    context 'with PromiseMessage' do
      let(:message) { Byzantine::Messages::PromiseMessage.new node_id: 1, key: 'key', sequence_number: 1 }

      context 'with wrong sequence_number' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 2) }

        it 'does not try to handle promise' do
          expect(proposer).not_to receive(:handle_promise)
          proposer.call
        end
      end

      context 'with proper sequence_number' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 1) }

        it 'tries to handle promise' do
          expect(proposer).to receive(:handle_promise)
          proposer.call
        end
      end

      context 'when data is not accepted and there is no quorum' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 1, value: 1, accepted: false) }

        it 'does not accept value' do
          expect(proposer).not_to receive(:accept_value)
          proposer.call
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, accepted: false, received_promise_number: 1)
          proposer.call
        end
      end

      context 'when data is accepted and there is quorum' do
        before do
          allow(session_store).to receive(:get)
            .and_return(sequence_number: 1, value: 1, accepted: true, received_promise_number: 1)
        end

        it 'does not accept value' do
          expect(proposer).not_to receive(:accept_value)
          proposer.call
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, accepted: true, received_promise_number: 2)
          proposer.call
        end
      end

      context 'when data is not accepted and there is quorum' do
        before do
          allow(session_store).to receive(:get)
            .and_return(sequence_number: 1, value: 1, accepted: false, received_promise_number: 1)
        end

        it 'accepts value' do
          expect(proposer).to receive(:accept_value).with(Hash)
          proposer.call
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, accepted: true, received_promise_number: 2)
          proposer.call
        end

        it 'calls DataStore set' do
          expect(data_store).to receive(:set).with('key', 1)
          proposer.call
        end

        it 'creates AcceptMessage' do
          expect(Byzantine::Messages::AcceptMessage).to receive(:new).with(node_id: 1, key: 'key', sequence_number: 1)
          proposer.call
        end

        it 'broadcasts AcceptMessage' do
          expect(distributed).to receive(:broadcast).with(Byzantine::Messages::AcceptMessage)
          proposer.call
        end
      end
    end
  end
end
