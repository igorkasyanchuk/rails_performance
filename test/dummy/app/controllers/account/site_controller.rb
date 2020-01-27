class Account::SiteController < ApplicationController
  protect_from_forgery except: :about

  def about
    sleep(rand(2.0))
    5.times { User.where(first_name: "X#{rand(100)}").count }

    respond_to do |format|
      format.html {}
      format.js { render text: "alert('hello');" }
    end
  end

  def crash
    1/0
  end

  def not_found
    User.find(0)
  end

  def is_redirect
    sleep(rand(2.0))
    redirect_to "/"
  end
end
