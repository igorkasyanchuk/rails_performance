RailsPerformance::Engine.routes.draw do
  root to: "rails_performance#index"

  get '/requests', to: 'rails_performance#requests'
  get '/crashes', to: 'rails_performance#crashes'
  get '/recent', to: 'rails_performance#recent'

  get '/trace/:id', to: 'rails_performance#trace', as: :trace
  get '/summary', to: 'rails_performance#summary'

  get '/jobs', to: 'rails_performance#jobs'
end
