class Worker1 < Grape::API
  desc "Returns pong."
  get :ping do
    sleep(rand(1000) * 0.001)
    {ping: params[:pong] || "pong"}
  end
end
