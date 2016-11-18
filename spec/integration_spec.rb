require 'socket'
require 'json'
require 'pry'
require 'fileutils'

RSpec.describe 'Integration' do
  let(:host)  { 'localhost' }
  let(:ports) { [4000, 5000, 6000, 7000] }

  let(:client_urls) do
    ports.map { |port| "#{host}:#{port}" }
  end

  let(:queue_urls) do
    ports.map { |port| "#{host}:#{port + 1}" }
  end

  let(:fault_tolerance) { 0 }

  let(:instances) do
    ports.map do |port|
      Byzantine::Runner.new.configure do |config|
        config.host            = host
        config.client_port     = port
        config.queue_port      = port + 1
        config.fault_tolerance = fault_tolerance
        config.node_urls       = queue_urls
        config.log_file        = '/dev/null'
      end
    end
  end

  let(:instance_runner) do
    InstanceRunner.new functional_instances
  end

  let(:client) { Client.new client_urls }

  let(:store_dir) { Dir.mktmpdir 'test_db' }

  before do
    stub_const 'Byzantine::Stores::PStore::STORE_DIR', store_dir
    instance_runner.start
  end

  after do
    instance_runner.stop
    FileUtils.remove_entry store_dir
  end

  describe 'getting values' do
    let(:functional_instances) { instances }

    let(:expected_response) do
      [
        { key: 'foo', value: nil },
        { key: 'foo', value: nil },
        { key: 'foo', value: nil },
        { key: 'foo', value: nil }
      ]
    end

    context 'when value not set' do
      it 'responds with nil values' do
        expect(client.get('foo')).to match_array expected_response
      end
    end
  end

  describe 'setting values' do
    context 'when all instances are functional' do
      let(:functional_instances) { instances }

      let(:expected_response) do
        [
          { key: 'foo', value: 'bar' },
          { key: 'foo', value: 'bar' },
          { key: 'foo', value: 'bar' },
          { key: 'foo', value: 'bar' }
        ]
      end

      it 'estabilishes consensus for set value' do
        client.set 'foo', 'bar'
        sleep 1
        expect(client.get('foo')).to match_array expected_response
      end
    end

    context 'when not all instances are functional' do
      context 'when quorum met' do
        let(:functional_instances) { instances[0..2] }

        let(:expected_response) do
          [
            { key: 'foo', value: 'bar' },
            { key: 'foo', value: 'bar' },
            { key: 'foo', value: 'bar' }
          ]
        end

        it 'estabilishes consensus for set value' do
          client.set 'foo', 'bar'
          sleep 1
          expect(client.get('foo')).to match_array expected_response
        end
      end

      context 'when quorum not met' do
        let(:functional_instances) { instances[0..1] }

        let(:expected_response) do
          [
            { key: 'foo', value: nil },
            { key: 'foo', value: nil }
          ]
        end

        it 'estabilishes consensus for set value' do
          client.set 'foo', 'bar'
          sleep 1
          expect(client.get('foo')).to match_array expected_response
        end
      end
    end
  end
end
