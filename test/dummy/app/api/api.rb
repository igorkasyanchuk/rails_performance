require_relative './demo/worker1.rb'
require_relative './demo/worker2.rb'
require_relative './demo/worker3.rb'

class API < Grape::API
  prefix 'api'
  format :json

  mount Demo::Worker1
  mount Demo::Worker2
  mount Demo::Worker3
end