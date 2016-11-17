RSpec.describe Byzantine::Configuration do
  describe 'getters' do
    it { is_expected.to respond_to :data_store_type }
    it { is_expected.to respond_to :session_store_type }
    it { is_expected.to respond_to :host }
    it { is_expected.to respond_to :client_port }
    it { is_expected.to respond_to :queue_port }
    it { is_expected.to respond_to :node_urls }
  end

  describe 'setters' do
    it { is_expected.to respond_to :data_store_type= }
    it { is_expected.to respond_to :session_store_type= }
    it { is_expected.to respond_to :host= }
    it { is_expected.to respond_to :client_port= }
    it { is_expected.to respond_to :queue_port= }
    it { is_expected.to respond_to :node_urls= }
  end

  describe '#initialize' do
    subject(:configuration) { described_class.new }

    it 'assigns default data_store_type value' do
      expect(configuration.instance_variable_get(:@data_store_type)).to eq(Byzantine::Stores::PStore)
    end

    it 'assigns default session_store_type value' do
      expect(configuration.instance_variable_get(:@session_store_type)).to eq(Byzantine::Stores::HashStore)
    end

    it 'assigns default host value' do
      expect(configuration.instance_variable_get(:@host)).to eq('localhost')
    end

    it 'assigns default client_port value' do
      expect(configuration.instance_variable_get(:@client_port)).to eq(4_000)
    end

    it 'assigns default queue_port value' do
      expect(configuration.instance_variable_get(:@queue_port)).to eq(4_001)
    end

    it 'assigns default node_urls value' do
      expect(configuration.instance_variable_get(:@node_urls)).to eq([])
    end
  end
end
