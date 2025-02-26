if defined?(RailsPerformance)
  RailsPerformance.setup do |config|
    # Redis configuration
    config.redis = Redis.new(url: ENV["REDIS_URL"].presence || "redis://127.0.0.1:6379/0")

    # All data we collect
    config.duration = 4.hours

    # Recent Requests configuration
    config.recent_requests_time_window = 60.minutes
    # config.recent_requests_limit = nil # number of recent requests

    # Slow Requests configuration
    config.slow_requests_time_window = 4.hours
    # config.slow_requests_limit = 500 # number of slow requests
    config.slow_requests_threshold = 500 # ms

    config.debug = false # currently not used>
    config.enabled = true

    # default path where to mount gem
    config.mount_at = "/rails/performance"

    # protect your Performance Dashboard with HTTP BASIC password
    config.http_basic_authentication_enabled = false
    config.http_basic_authentication_user_name = "rails_performance"
    config.http_basic_authentication_password = "password12"

    # if you need an additional rules to check user permissions
    config.verify_access_proc = proc { |controller| true }
    # for example when you have `current_user`
    # config.verify_access_proc = proc { |controller| controller.current_user && controller.current_user.admin? }

    # You can ignore endpoints with Rails standard notation controller#action
    # config.ignored_endpoints = ['HomeController#contact']

    # You can ignore request paths by specifying the beginning of the path.
    # For example, all routes starting with '/admin' can be ignored:
    config.ignored_paths = ["/rails/performance"]

    # store custom data for the request
    # config.custom_data_proc = proc do |env|
    #   request = Rack::Request.new(env)
    #   {
    #     email: request.env['warden'].user&.email, # if you are using Devise for example
    #     user_agent: request.env['HTTP_USER_AGENT']
    #   }
    # end

    # config home button link
    config.home_link = "/"
    config.skipable_rake_tasks = ["webpacker:compile"]
    config.include_rake_tasks = false
    config.include_custom_events = true

    # If enabled, the system monitor will be displayed on the dashboard
    # to enabled add required gems (see README)
    # config.system_monitor_duration = 24.hours
  end
end
