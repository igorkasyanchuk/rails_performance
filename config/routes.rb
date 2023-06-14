RailsPerformance::Engine.routes.draw do
  get '/'          => 'rails_performance#index', as: :rails_performance

  get '/requests'  => 'rails_performance#requests', as: :rails_performance_requests
  get '/crashes'   => 'rails_performance#crashes', as: :rails_performance_crashes
  get '/recent'    => 'rails_performance#recent', as: :rails_performance_recent
  get '/slow'      => 'rails_performance#slow', as: :rails_performance_slow

  get '/trace/:id'  => 'rails_performance#trace', as: :rails_performance_trace
  get '/summary'    => 'rails_performance#summary', as: :rails_performance_summary

  get '/sidekiq'    => 'rails_performance#sidekiq', as: :rails_performance_sidekiq
  get '/delayed_job'=> 'rails_performance#delayed_job', as: :rails_performance_delayed_job
  get '/grape'      => 'rails_performance#grape', as: :rails_performance_grape
  get '/rake'       => 'rails_performance#rake', as: :rails_performance_rake
  get '/custom'     => 'rails_performance#custom', as: :rails_performance_custom
end

Rails.application.routes.draw do
  begin
    mount RailsPerformance::Engine => RailsPerformance.mount_at, as: 'rails_performance'
  rescue ArgumentError
      # already added
      # this code exist here because engine not includes routing automatically
  end
end
