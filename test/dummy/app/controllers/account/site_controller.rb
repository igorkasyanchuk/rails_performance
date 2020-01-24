class Account::SiteController < ApplicationController
  def about
    5.times { User.where(first_name: "X#{rand(100)}").count }
  end
end
