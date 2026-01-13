class MyJob < ApplicationJob
  self.queue_adapter = :solid_queue

  queue_as :default

  def perform(*args)
    timer = rand(5000) / 1000.0
    sleep(timer)
    # to test during development
    # File.open("tmp/my_job.txt", "a") { |f| f.puts "MyJob performed at #{Time.current}" }
    1 / 0 if rand(1..10) == 1
    42
  end
end
