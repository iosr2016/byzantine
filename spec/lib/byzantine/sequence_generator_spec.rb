RSpec.describe Byzantine::SequenceGenerator do
  describe '#generate_number' do
    subject(:generator) { described_class.new base_number: base_number }

    context 'with base number' do
      let(:base_number) { 1 }

      it 'returns increased number' do
        expect(generator.generate_number).to eq(base_number + 1)
      end

      it 'does not call SecureRandom' do
        expect(SecureRandom).not_to receive(:random_number)
        generator.generate_number
      end
    end

    context 'without base number' do
      let(:base_number) { nil }

      it 'returns number' do
        expect(generator.generate_number).to be_a(Integer)
      end

      it 'calls SecureRandom' do
        expect(SecureRandom).to receive(:random_number).with(1_000)
        generator.generate_number
      end
    end
  end
end
