RSpec.describe Byzantine::Handlers::AcceptHandler do
  describe '#handle' do
    let(:data_store) { instance_double Byzantine::Stores::PStore, set: true }
    let(:session_store) { instance_double Byzantine::Stores::PStore, set: true }
    let(:distributed) { instance_double Byzantine::Distributed, node_by_id: true, broadcast: true, nodes: [1, 2, 3] }
    let(:context) do
      instance_double Byzantine::Context, data_store: data_store, session_store: session_store,
                                          distributed: distributed, fault_tolerance: 0
    end
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

      it 'tries to handle accept' do
        expect(accept_handler).to receive(:handle_accept)
        accept_handler.handle
      end

      context 'when data is not decided and there is no strong quorum' do
        before { allow(session_store).to receive(:get).and_return(sequence_number: 1, value: 1, decided: false) }

        it 'does not decide' do
          expect(accept_handler).not_to receive(:decide)
          accept_handler.handle
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, decided: false, strong_accepted_count: 1)
          accept_handler.handle
        end
      end

      context 'when data is decided and there is strong quorum' do
        before do
          allow(session_store).to receive(:get)
            .and_return(sequence_number: 1, value: 1, decided: true, strong_accepted_count: 1)
        end

        it 'does not decide' do
          expect(accept_handler).not_to receive(:decide)
          accept_handler.handle
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, decided: true, strong_accepted_count: 2)
          accept_handler.handle
        end
      end

      context 'when data is not decided and there is strong quorum' do
        before do
          allow(session_store).to receive(:get)
            .and_return(sequence_number: 1, value: 1, decided: false, strong_accepted_count: 1)
        end

        it 'decides' do
          expect(accept_handler).to receive(:decide)
          accept_handler.handle
        end

        it 'calls SessionStore set' do
          expect(session_store).to receive(:set)
            .with('key', sequence_number: 1, value: 1, decided: true, strong_accepted_count: 2)
          accept_handler.handle
        end

        it 'calls DataStore set' do
          expect(data_store).to receive(:set).with('key', value: 1, sequence_number: 1)
          accept_handler.handle
        end
      end
    end
  end
end
