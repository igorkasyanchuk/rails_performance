Rails.application.routes.draw do
  namespace :account do
    get 'site/about'
  end
  get 'home/index'
  get 'home/about'
  get 'home/about.csv', to: 'home#about'
  root to: 'home#index'
end
