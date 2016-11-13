RSpec.describe Byzantine::Handlers::PromiseHandler do
  describe '#handle' do
    let(:data_store) { instance_double Byzantine::Stores::PStore, set: true }
    let(:session_store) { instance_double Byzantine::Stores::PStore, set: true }
    let(:distributed) { instance_double Byzantine::Distributed, node_by_id: true, broadcast: true, nodes: [1, 2, 3] }
    let(:context) do
      instance_double Byzantine::Context, data_store: data_store, session_store: session_store,
                                          distributed: distributed, node_id: 1, fault_tolerance: 0
    end
    let(:message) { Byzantine::Messages::PromiseMessage.new node_id: 1, key: 'key', sequence_number: 1, value: 1 }

    subject(:promise_handler) { described_class.new context, message }
    before { allow(session_store).to receive(:get).and_return(sequence_number: 0) }

    context 'with wrong sequence_number' do
      before { allow(session_store).to receive(:get).and_return(sequence_number: 2) }

      it 'does not try to handle promise' do
        expect(promise_handler).not_to receive(:handle_promise)
        promise_handler.handle
      end
    end

    context 'with wrong value' do
      before { allow(session_store).to receive(:get).and_return(sequence_number: 2, value: 2) }

      it 'does not try to handle promise' do
        expect(promise_handler).not_to receive(:handle_promise)
        promise_handler.handle
      end
    end

    context 'with proper sequence_number and value' do
      before { allow(session_store).to receive(:get).and_return(sequence_number: 1, value: 1) }

      it 'tries to handle promise' do
        expect(promise_handler).to receive(:handle_promise)
        promise_handler.handle
      end

      context 'when data is not accepted and there is no weak quorum' do
        before do
          allow(session_store).to receive(:get).and_return(sequence_number: 1, value: 1, strong_accepted: false)
        end

        it 'does not make strong acceptance' do
          expect(promise_handler).not_to receive(:strong_acceptance)
          promise_handler.handle
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, strong_accepted: false, weak_accepted_count: 1)
          promise_handler.handle
        end
      end

      context 'when data is accepted and there is weak quorum' do
        before do
          allow(session_store).to receive(:get)
            .and_return(sequence_number: 1, value: 1, strong_accepted: true, weak_accepted_count: 1)
        end

        it 'does not make strong acceptance' do
          expect(promise_handler).not_to receive(:strong_acceptance)
          promise_handler.handle
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, strong_accepted: true, weak_accepted_count: 2)
          promise_handler.handle
        end
      end

      context 'when data is not accepted and there is weak quorum' do
        before do
          allow(session_store).to receive(:get)
            .and_return(sequence_number: 1, value: 1, strong_accepted: false, weak_accepted_count: 1)
        end

        it 'makes strong acceptance' do
          expect(promise_handler).to receive(:strong_acceptance).with(Hash)
          promise_handler.handle
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, strong_accepted: true, weak_accepted_count: 2)
          promise_handler.handle
        end

        it 'creates AcceptMessage' do
          expect(Byzantine::Messages::AcceptMessage).to receive(:new).with(node_id: 1, key: 'key', sequence_number: 1)
          promise_handler.handle
        end

        it 'broadcasts AcceptMessage' do
          expect(distributed).to receive(:broadcast).with(Byzantine::Messages::AcceptMessage)
          promise_handler.handle
        end
      end
    end
  end
end
