class Worker3 < Grape::API
  desc "Make crash"
  get :crash do
    1 / 0
  end
end
