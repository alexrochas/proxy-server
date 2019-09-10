# REST server
require "sinatra"
require "sinatra/multi_route"

class RESTServer < Sinatra::Base

  set :bind, '0.0.0.0'
  set :port, 4567

  get '/proxy.pac' do
    puts 'Autoproxy request!'
    send_file File.join( 'proxy.pac')
  end

  get "/trace" do
    puts "Incoming request to #{request.path_info} with body #{request.body.read.to_s} and query params #{params}"
    "Up and kicking!"
  end

end

RESTServer.run!
