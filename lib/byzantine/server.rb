require 'socket'
require 'json'

module Byzantine
  class Server < BaseServer
    private

    def handle_request
      accept_incoming do |client|
        request   = parse_request client.gets.chomp!
        response  = send "handle_#{request[:type]}", request

        client.puts response.to_json
      end
    end

    def parse_request(raw_request)
      JSON.parse(raw_request, symbolize_names: true)
    end

    def handle_get(request)
      {
        key:    request[:key],
        value:  context.data_store.get(request[:key])
      }
    end

    def handle_set(request)
      message = Messages::RequestMessage.new(node_id: context.node_id, key: request[:key], value: request[:value])
      Handlers::RequestHandler.new(context, message).handle

      { key: request[:key] }
    end
  end
end
