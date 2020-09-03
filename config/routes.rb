RailsPerformance::Engine.routes.draw do
  get '/'          => 'rails_performance#index', as: :rails_performance

  get '/requests'  => 'rails_performance#requests', as: :rails_performance_requests
  get '/crashes'   => 'rails_performance#crashes', as: :rails_performance_crashes
  get '/recent'    => 'rails_performance#recent', as: :rails_performance_recent

  get '/trace/:id'  => 'rails_performance#trace', as: :rails_performance_trace
  get '/summary'    => 'rails_performance#summary', as: :rails_performance_summary

  get '/jobs'       => 'rails_performance#jobs', as: :rails_performance_jobs
end

Rails.application.routes.draw do
  begin
    mount RailsPerformance::Engine => RailsPerformance.mount_at, as: 'rails_performance'
  rescue ArgumentError
      # already added
      # this code exist here because engine not includes routing automatically
  end
end