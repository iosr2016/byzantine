require 'sinatra'
require './config/environment'

get '/' do
  'Hello Paxos!'
end

get '/get/:value' do
end
