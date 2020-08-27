module RailsPerformance
  class BaseController < ActionController::Base
    layout 'rails_performance/layouts/rails_performance'

    before_action :verify_access

    if RailsPerformance.http_basic_authentication_enabled
      http_basic_authenticate_with \
        name: RailsPerformance.http_basic_authentication_user_name,
        password: RailsPerformance.http_basic_authentication_password
    end

    private

    def verify_access
      result = RailsPerformance.verify_access_proc.call(self)
      redirect_to('/', error: 'Access Denied', status: 401) unless result
    end

  end
end