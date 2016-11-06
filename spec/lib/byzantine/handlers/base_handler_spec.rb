RSpec.describe Byzantine::Handlers::BaseHandler do
  describe '#initialize' do
    let(:context) { instance_double Byzantine::Context }
    let(:message) { instance_double Byzantine::Messages::BaseMessage }

    it 'assigns context' do
      handler = described_class.new(context, nil)
      expect(handler.context).to eq(context)
    end

    it 'assigns message' do
      handler = described_class.new(nil, message)
      expect(handler.message).to eq(message)
    end
  end

  describe '#handle' do
    subject(:handler) { described_class.new nil, nil }

    it 'raises error' do
      expect { handler.handle }.to raise_error(NotImplementedError, 'Implement this method in derived class.')
    end
  end
end
