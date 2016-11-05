require 'rubygems'
require 'bundler'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require './lib/paxos'

client = Paxos::Client.new

client.configure do |config|
  config.node_id = 0
  config.nodes_config = [
    'http://example1.com:5000#1',
    'http://example2.com:5000#2',
    'http://example3.com:5000#3'
  ]
end

$client = client # rubocop:disable Style/GlobalVars
