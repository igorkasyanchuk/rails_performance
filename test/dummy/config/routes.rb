Rails.application.routes.draw do
  devise_for :users

  namespace :account do
    get "site/about"
    get "site/crash"
    get "site/not_found"
    get "site/is_redirect"
  end
  get "home/index"
  get "home/contact"
  get "home/about"
  get "home/blog"
  get "home/about.csv", to: "home#about"

  mount API => "/"

  root to: "home#index"
end
