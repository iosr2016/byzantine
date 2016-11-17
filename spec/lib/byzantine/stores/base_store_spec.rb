RSpec.describe Byzantine::Stores::BaseStore do
  subject(:store) { described_class.new 'name' }

  describe '#initialize' do
    it 'assings proper name' do
      expect(store.name).to eq('name')
    end
  end

  describe '#set' do
    it 'raises error' do
      expect { store.set('k', 'v') }.to raise_error(NotImplementedError, 'Implement this method in derived class.')
    end
  end

  describe '#get' do
    it 'raises error' do
      expect { store.get('k') }.to raise_error(NotImplementedError, 'Implement this method in derived class.')
    end
  end
end
