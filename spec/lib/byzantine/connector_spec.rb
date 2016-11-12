RSpec.describe Byzantine::Connector do
  let(:node) { instance_double Byzantine::Node, host: 'h', port: 'p' }
  subject(:connector) { described_class.new node }

  describe '#initialize' do
    it 'assigns node' do
      expect(connector.node).to be(node)
    end
  end

  describe '#send' do
    let(:socket) { instance_double TCPSocket, puts: true }

    it 'creates TCPSocket' do
      expect(TCPSocket).to receive(:new).with('h', 'p').and_return(socket)
      connector.send('message')
    end

    it 'dumps message' do
      allow(TCPSocket).to receive(:new).and_return(socket)
      expect(Marshal).to receive(:dump).with('message')
      connector.send('message')
    end

    it 'sends message' do
      allow(TCPSocket).to receive(:new).and_return(socket)
      expect(socket).to receive(:puts).with(String)
      connector.send('message')
    end

    context 'with multiple sends' do
      it 'creates new TCPSocket once' do
        expect(TCPSocket).to receive(:new).with('h', 'p').and_return(socket).once
        connector.send('message')
        connector.send('message')
      end
    end
  end
end
