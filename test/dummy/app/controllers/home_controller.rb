class HomeController < ApplicationController
  def index
    sleep(rand(2.0))
    100.times { User.where(first_name: "X#{rand(100)}").count }
  end

  def about
    sleep(rand(2.0))
    50.times { User.where(first_name: "X#{rand(100)}").count }
  end

  def contact
    sleep(rand(2.0))
    2.times { User.where(first_name: "X#{rand(100)}").count }
  end

  def blog
    sleep(rand(2.0))
    2.times { User.where(first_name: "X#{rand(100)}").count }
  end
end
