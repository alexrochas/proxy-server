#!/usr/bin/env ruby

# Proxy server
require 'webrick'
require 'webrick/httpproxy'
require 'net/http'

token = `ztoken`

Thread.new do
  loop do
    sleep(5 * 60)
    puts('Updating token!')
    token = `ztoken`
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
