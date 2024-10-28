module Demo
  class Worker1 < Grape::API
    desc "Returns pong."
    get :ping do
      sleep(rand(2.0))
      {ping: params[:pong] || "pong"}
    end
  end
end
