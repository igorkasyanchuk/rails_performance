class Account::SiteController < ApplicationController
  protect_from_forgery except: :about

  def about
    SecondWorker.perform_async
    sleep(rand(500) * 0.001)
    5.times { User.where(first_name: "X#{rand(100)}").count }
    User.create.say_hello
    User.create.say_hello_without_delay
    respond_to do |format|
      format.html {}
      format.js { render text: "alert('hello');" }
    end
  end

  def crash
    1 / 0
  end

  def not_found
    SecondWorker.perform_async
    User.find(0)
  end

  def is_redirect
    SecondWorker.perform_async
    sleep(rand(500) * 0.001)
    redirect_to "/"
  end
end
