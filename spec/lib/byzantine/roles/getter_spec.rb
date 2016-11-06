RSpec.describe Byzantine::Roles::Getter do
  describe '#call' do
    let(:data_store) { instance_double Byzantine::Persistence::PStore }
    let(:context) { instance_double Byzantine::Context, data_store: data_store }
    subject(:getter) { described_class.new context, message }

    context 'with GetMessage' do
      let(:message) { Byzantine::Messages::GetMessage.new node_id: nil, key: 'test_key' }

      it 'calls data_store get' do
        expect(data_store).to receive(:get).with('test_key')
        getter.call
      end
    end
  end
end
