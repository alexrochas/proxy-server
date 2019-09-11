#!/usr/bin/env ruby

# Proxy server
require 'webrick'
require 'webrick/httpproxy'
require 'net/http'

@@token = `ztoken`

Thread.new do
  loop do
    sleep(5 * 60)
    puts('Updating token!')
    @@token = `ztoken`
  end
end

class ZProxy < WEBrick::HTTPProxyServer
  def do_GET(req, res)
    puts('Enhancing request!')
    req.header['Authorization'] = ["Bearer #{@@token}"]
    req.raw_header << "Authorization: Bearer #{@@token}"
    perform_proxy_request(req, res, Net::HTTP::Get)
  end

  def do_CONNECT(req, res)
    puts('Enhancing HTTPS request!')
    req.raw_header << "Authorization: Bearer #{@@token}"
    req.header['Authorization'] = ["Bearer #{@@token}"]
    super(req, res)
  end
end

proxy = ZProxy.new Port: 3000

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
