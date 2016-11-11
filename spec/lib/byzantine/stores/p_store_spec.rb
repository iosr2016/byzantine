RSpec.describe Byzantine::Stores::PStore do
  describe '#initialize' do
    it 'creates store directory' do
      expect(FileUtils).to receive(:mkdir_p).with(described_class::STORE_DIR)
      described_class.new('name')
    end
  end

  describe '#set' do
    subject(:store) { described_class.new 'name' }
    let(:p_store) { instance_double PStore, transaction: true }

    it 'creates new PStore' do
      expect(PStore).to receive(:new).with('.db/name.pstore').and_return(p_store)
      store.set('key', 'value')
    end

    it 'writes data in transaction' do
      allow(PStore).to receive(:new).and_return(p_store)
      expect(p_store).to receive(:transaction)
      store.set('key', 'value')
    end

    it 'writes data' do
      allow(PStore).to receive(:new).and_return(p_store)
      allow(p_store).to receive(:transaction).and_yield
      expect(p_store).to receive(:[]=).with('key', 'value')
      store.set('key', 'value')
    end

    context 'with multiple writes' do
      it 'creates new PStore once' do
        expect(PStore).to receive(:new).with('.db/name.pstore').and_return(p_store).once
        store.set('key', 'value')
        store.set('key', 'value')
      end
    end
  end

  describe '#get' do
    subject(:store) { described_class.new 'name' }
    let(:p_store) { instance_double PStore, transaction: true }

    it 'creates new PStore' do
      expect(PStore).to receive(:new).with('.db/name.pstore').and_return(p_store)
      store.get('key')
    end

    it 'reads data in transaction' do
      allow(PStore).to receive(:new).and_return(p_store)
      expect(p_store).to receive(:transaction).with(true)
      store.get('key')
    end

    it 'reads data' do
      allow(PStore).to receive(:new).and_return(p_store)
      allow(p_store).to receive(:transaction).and_yield
      expect(p_store).to receive(:[]).with('key')
      store.get('key')
    end

    context 'with multiple reads' do
      it 'creates new PStore once' do
        expect(PStore).to receive(:new).with('.db/name.pstore').and_return(p_store).once
        store.get('key')
        store.get('key')
      end
    end
  end
end
