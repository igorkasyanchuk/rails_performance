class HomeController < ApplicationController
  def index
    100.times { User.where(first_name: "X#{rand(100)}").count }
  end

  def about
    50.times { User.where(first_name: "X#{rand(100)}").count }
  end

  def contact
    2.times { User.where(first_name: "X#{rand(100)}").count }
  end
end
