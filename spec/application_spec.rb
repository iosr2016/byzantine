RSpec.describe 'Application' do
  describe 'GET /' do
    before { get '/' }

    it 'responds with data' do
      expect(last_response.body).to eq 'Hello Paxos!'
    end

    it 'responds with status 200 ok' do
      expect(last_response.status).to eq 200
    end
  end
end
