require_relative "demo/worker1"
require_relative "demo/worker2"
require_relative "demo/worker3"

class API < Grape::API
  prefix "api"
  format :json

  mount Demo::Worker1
  mount Demo::Worker2
  mount Demo::Worker3
end
