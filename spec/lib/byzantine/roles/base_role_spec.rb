RSpec.describe Byzantine::Roles::BaseRole do
  describe '#initialize' do
    let(:context) { instance_double Byzantine::Context }
    let(:message) { instance_double Byzantine::Messages::BaseMessage }

    it 'assigns context' do
      role = described_class.new(context, nil)
      expect(role.context).to eq(context)
    end

    it 'assigns message' do
      role = described_class.new(nil, message)
      expect(role.message).to eq(message)
    end
  end

  describe '#call' do
    subject(:role) { described_class.new nil, nil }

    it 'raises error' do
      expect { role.call }.to raise_error(NotImplementedError, 'Implement this method in derived class.')
    end
  end
end
