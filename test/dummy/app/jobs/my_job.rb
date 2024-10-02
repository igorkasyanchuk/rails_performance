class MyJob < ApplicationJob
  self.queue_adapter = :solid_queue

  queue_as :default

  def perform(*args)
    sleep(rand(1..3))
    # to test during development
    # File.open("tmp/my_job.txt", "a") { |f| f.puts "MyJob performed at #{Time.current}" }
    1/0 if rand(1..3) == 1
    42
  end
end
