RailsPerformance::Engine.routes.draw do
  get '/' => 'rails_performance#index', as: :rails_performance
end

Rails.application.routes.draw do
  begin
    mount RailsPerformance::Engine => '/rails/performance', as: 'rails_performance'
  rescue ArgumentError
      # already added
      # this cod exist here because engine not includes routing automatically
  end
end