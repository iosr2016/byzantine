require 'socket'
require 'timeout'
require 'json'

class Client
  Instance = Struct.new :host, :port

  attr_reader :instances

  def initialize(urls)
    @instances = build_instances urls
  end

  def set(key, value)
    perform_request receivers: [instances.first],
                    type:      'set',
                    params:    { key: key, value: value }
  end

  def get(key)
    perform_request receivers: instances,
                    type:      'get',
                    params:    { key: key }
  end

  private

  def perform_request(receivers:, type:, params: {})
    receivers.map do |receiver|
      request = { type: type }.merge! params

      raw_response = send_to receiver, request
      next unless raw_response

      JSON.parse raw_response, symbolize_names: true
    end.compact
  end

  def send_to(receiver, request)
    socket = TCPSocket.new receiver.host, receiver.port

    raw_response = nil

    Timeout.timeout(5) do
      socket.puts request.to_json
      raw_response = socket.gets
    end

    raw_response
  rescue Timeout::Error
    nil
  rescue Errno::ECONNREFUSED
    nil
  end

  def build_instances(urls)
    urls.map do |url|
      host, port = url.split ':'
      Instance.new host, port
    end
  end
end
