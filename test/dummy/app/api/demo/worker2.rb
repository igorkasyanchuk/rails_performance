module Demo
  class Worker2 < Grape::API
    desc "Returns users."
    get :users do
      sleep(rand(4.0))
      User.limit(10).order("random()")
    end
  end
end
