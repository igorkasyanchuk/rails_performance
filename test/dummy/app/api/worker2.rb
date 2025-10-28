class Worker2 < Grape::API
  desc "Returns users."
  get :users do
    sleep(rand(2000) * 0.001)
    User.limit(10).order("random()")
  end
end
