require 'rubygems'
require 'bundler'

Bundler.require(:default)
Bundler.require(Sinatra::Base.environment)

require './lib/paxos'

$client = Paxos::Client.new # rubocop:disable Style/GlobalVars
