require "sinatra"
require "sinatra/multi_route"

set :bind, '0.0.0.0'

route :get, :post, :put, :delete, :patch, "/*" do
  puts "Incoming request to #{request.path_info} with body #{request.body.read.to_s} and query params #{params}"
  {:resultado => '00', :dataHora => '0802221226'}.to_json
end
