class AdvancedWorker
  include Sidekiq::Worker

  def perform(*args)
    sleep(rand(15.0))
  end
end
