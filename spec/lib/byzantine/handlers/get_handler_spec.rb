RSpec.describe Byzantine::Handlers::GetHandler do
  describe '#handle' do
    let(:data_store) { instance_double Byzantine::Stores::PStore }
    let(:context) { instance_double Byzantine::Context, data_store: data_store }
    let(:message) { Byzantine::Messages::GetMessage.new node_id: nil, key: 'test_key' }
    subject(:get_handler) { described_class.new context, message }

    it 'calls data_store get' do
      expect(data_store).to receive(:get).with('test_key')
      get_handler.handle
    end
  end
end
