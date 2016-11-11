RSpec.describe Byzantine::MessageHandler do
  let(:context) { instance_double Byzantine::Context }
  subject(:handler) { described_class.new context }

  describe '#initialize' do
    it 'assigns context' do
      expect(handler.context).to be(context)
    end
  end

  describe '#handle' do
    let(:base_handler) { instance_double Byzantine::Handlers::BaseHandler, handle: true }
    let(:dispatcher) { instance_double Byzantine::MessageDispatcher, dispatch: base_handler }

    it 'creates Message Dispatcher' do
      expect(Byzantine::MessageDispatcher).to receive(:new).with(context).and_return(dispatcher)
      handler.handle 'message'
    end

    it 'calls Message Dispatcher' do
      allow(Byzantine::MessageDispatcher).to receive(:new).and_return(dispatcher)
      expect(dispatcher).to receive(:dispatch).with('message').and_return(base_handler)
      handler.handle 'message'
    end
  end
end
