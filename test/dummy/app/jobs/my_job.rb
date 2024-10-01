class MyJob < ApplicationJob
  self.queue_adapter = :solid_queue

  queue_as :default

  def perform(*args)
    puts '--1--'
    sleep(rand(1..5))
    File.open("tmp/my_job.txt", "a") { |f| f.puts "MyJob performed at #{Time.current}" }
    42
    puts '--2--'
  end
end
