class SecondWorker
  include Sidekiq::Worker

  def perform(*args)
    sleep(rand(1000) / 100.0)
  end
end
