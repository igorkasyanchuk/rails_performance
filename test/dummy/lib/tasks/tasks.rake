desc 'Say hello!'
task :task1 do
  puts "Hello ZZZ"
  sleep(rand(0.2))
end

desc 'Say nested hello!'
task :task2 => :task1 do
  sleep(rand(0.2))
  puts "Hello YYY"
end

desc 'Say crash!'
task :task3 do
  1/0
end