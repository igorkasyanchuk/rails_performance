module RailsPerformance
  class BaseController < ActionController::Base
    include RailsPerformance::Concerns::CsvExportable

    layout "rails_performance/layouts/rails_performance"

    before_action :verify_access
    after_action :set_permissive_csp

    if RailsPerformance.http_basic_authentication_enabled
      http_basic_authenticate_with \
        name: RailsPerformance.http_basic_authentication_user_name,
        password: RailsPerformance.http_basic_authentication_password
    end

    def url_options
      RailsPerformance.url_options.nil? ? super : RailsPerformance.url_options
    end

    private

    def verify_access
      result = RailsPerformance.verify_access_proc.call(self)
      redirect_to("/", error: "Access Denied", status: 401) unless result
    end

    def set_permissive_csp
      response.headers["Content-Security-Policy"] = "default-src 'self' https:; script-src 'self' 'unsafe-inline' 'unsafe-eval' https:; style-src 'self' 'unsafe-inline' https:"
    end
  end
end
