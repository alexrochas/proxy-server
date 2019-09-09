#!/usr/bin/env ruby

# Set proxy in Mac OS
# networksetup -setautoproxyurl "Wi-Fi" "http://localhost:4567/proxy.pac"

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

Thread.new do
  RESTServer.run!
end

# Proxy server
require 'webrick'
require 'webrick/httpproxy'
require 'net/http'

token = %[ztoken]

Thread.new do
  loop do
    sleep(5 * 60)
    puts('Updating token!')
    token = %[ztoken]
  end
end

handler = proc do |req, res|
  puts('Enhancing request!')
	req.header['Authorization'] = token
end

proxy = WEBrick::HTTPProxyServer.new Port: 3000, ProxyContentHandler: handler

trap 'INT'  do proxy.shutdown end
trap 'TERM' do proxy.shutdown end

proxy.start

Signal.trap('INT') { throw :force_shutdown } # Trap ^C
Signal.trap('TERM') { throw :force_shutdown } # Trap `Kill `

catch(:force_shutdown) {
  puts("Force shutdown!")
  proxy.stop
  exit
}
