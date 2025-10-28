require_relative "worker1"
require_relative "worker2"
require_relative "worker3"

class API < Grape::API
  prefix "api"
  format :json

  mount Worker1
  mount Worker2
  mount Worker3
end
