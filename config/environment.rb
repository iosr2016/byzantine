require 'rubygems'
require 'bundler'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require './lib/paxos'

server = Paxos::Server.new

server.configure do |config|
  config.port = 4000
  config.node_id = 0
  config.nodes_config = [
    'http://example1.com:5000#1',
    'http://example2.com:5000#2',
    'http://example3.com:5000#3'
  ]
end

$server = server # rubocop:disable Style/GlobalVars
