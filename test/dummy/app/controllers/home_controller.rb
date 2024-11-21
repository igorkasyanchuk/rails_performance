class HomeController < ApplicationController
  def index
    rand(10).times { AdvancedWorker.perform_async }
    SecondWorker.perform_async

    100000.times { rand(1000000000) / rand(1000232323.9) }

    sleep(rand(500) * 0.001)
    10.times { User.where(first_name: "X#{rand(100)}").count }
    RailsPerformance.measure "index", "home controller" do
      sleep(0.1)
      50 + 50
    end
  end

  def about
    sleep(rand(500) * 0.001)
    rand(10).times { SimpleWorker.perform_async }
    10.times { User.where(first_name: "X#{rand(100)}").count }

    sign_in User.all.sample
  end

  def contact
    sleep(rand(500) * 0.001)
    rand(5).times { SimpleWorker.perform_async }
    rand(3).times { AdvancedWorker.perform_async }
    10.times { User.where(first_name: "X#{rand(100)}").count }
    10.times { User.where(first_name: "Super mega cool" * 20, age: 88, id: [1..100].to_a).count }
  end

  def blog
    rand(3).times { AdvancedWorker.perform_async }
    sleep(rand(1000) * 0.001)
    2.times { User.where(first_name: "X#{rand(100)}").count }
  end
end
