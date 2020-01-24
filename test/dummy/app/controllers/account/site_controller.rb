class Account::SiteController < ApplicationController
  def about
    5.times { User.where(first_name: "X#{rand(100)}").count }
  end

  def crash
    1/0
  end

  def not_found
    User.find(0)
  end

  def is_redirect
    redirect_to "/"
  end
end
