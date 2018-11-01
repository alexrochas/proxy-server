require "sinatra"
require "sinatra/multi_route"

set :bind, '0.0.0.0'
domain = 'dev'
port = '4567'

get '/autoproxy.pac' do
  puts 'Autoproxy request!'
  headers['Content-Type'] = 'application/x-ns-proxy-autoconfig'
  """function FindProxyForURL (url, host) {
    if (shExpMatch(url, \"*.#{dev}\")) {
      return \"PROXY 127.0.0.1:#{port}\";
    }
    return 'DIRECT';
  }"""
end

route :get, :post, :put, :delete, :patch, "/*" do
  puts "Incoming request to #{request.path_info} with body #{request.body.read.to_s} and query params #{params}"
  "Up and kicking!"
end

