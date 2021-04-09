require_relative './demo/worker1.rb'
require_relative './demo/worker2.rb'

class API < Grape::API
  prefix 'api'
  format :json

  mount Demo::Worker1
  mount Demo::Worker2
end