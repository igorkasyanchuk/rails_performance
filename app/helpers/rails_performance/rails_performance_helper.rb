module RailsPerformance
  module RailsPerformanceHelper

    def round_it(value, limit = 1)
      return nil unless value
      return value if value.is_a?(Integer)

      value.nan? ? nil : value.round(limit)
    end

    def duraction_alert_class(duration_str)
      if duration_str.to_s =~ /(\d+.?\d+?)/
        duration = $1.to_f
        if duration >= 500
          'has-background-danger has-text-white-bis'
        elsif duration >= 200
          'has-background-warning has-text-black-ter'
        else
          'has-background-success has-text-white-bis'
        end
      else
        'has-background-light'
      end
    end

    def extract_duration(str)
      if (str =~ /Duration: (\d+.?\d+?ms)/i)
        $1
      else
        '-'
      end
    end

    def mss(value, limit = 1)
      ms(value.to_f * 1000, limit)
    end

    def ms(value, limit = 1)
      result = round_it(value, limit)
      return '-' if result.nil?

      result && result != 0 ? "#{result} ms" : '< 0 ms'
    end

    def short_path(path, length: 55)
      content_tag :span, title: path do
        truncate(path, length: length)
      end
    end

    def link_to_path(e)
      if e[:method] == 'GET'
        link_to(short_path(e[:path]), e[:path], target: '_blank', title: short_path(e[:path]))
      else
        short_path(e[:path])
      end
    end

    def report_name(h)
      h.except(:on).collect do |k, v|
        next if v.blank?

        %Q{
        <div class="control">
          <span class="tags has-addons">
            <span class="tag">#{k}</span>
            <span class="tag is-info is-light">#{v}</span>
          </span>
        </div>}
      end.compact.join.html_safe
    end

    def status_tag(status)
      klass = case status.to_s
      when /error/
        "tag is-danger"
      when /^5/
        "tag is-danger"
      when /^4/
        "tag is-warning"
      when /^3/
        "tag is-info"
      when /^2/
        "tag is-success"
      when /success/
        "tag is-success"
      else
        nil
      end
      content_tag(:span, class: klass) do
        status
      end
    end

    def bot_icon(user_agent)
      return nil if user_agent.blank?

      browser = Browser.new(user_agent)
      if browser.bot?
        content_tag(:span, class: "user-agent-icon", title: browser.bot&.name) do
          icon("bot")
        end
      else
        content_tag(:span, class: "user-agent-icon user-agent-icon-user", title: "Real User") do
          icon("user")
        end
      end
    end

    def icon(name)
      @icons ||= {}
      @icons[name] ||= begin
        # https://www.iconfinder.com/iconsets/vivid
        raw File.read(File.expand_path(File.dirname(__FILE__) +  "/../../assets/images/#{name}.svg"))
      end
    end

    def insert_css_file(file)
      raw "<style>#{raw File.read File.expand_path(File.dirname(__FILE__) + "/../../views/rails_performance/stylesheets/#{file}")}</style>"
    end

    def insert_js_file(file)
      raw "<script>#{raw File.read File.expand_path(File.dirname(__FILE__) + "/../../views/rails_performance/javascripts/#{file}")}</script>"
    end

    def format_datetime(e)
      dt = RailsPerformance::Reports::BaseReport::time_in_app_time_zone(e)
      I18n.l(dt, format: "%Y-%m-%d %H:%M:%S")
    end

    def active?(section)
      case section
      when :dashboard
        "is-active" if controller_name == "rails_performance" && action_name == "index"
      when :crashes
        "is-active" if controller_name == "rails_performance" && action_name == "crashes"
      when :requests
        "is-active" if controller_name == "rails_performance" && action_name == "requests"
      when :recent
        "is-active" if controller_name == "rails_performance" && action_name == "recent"
      when :slow
        "is-active" if controller_name == "rails_performance" && action_name == "slow"
      when :sidekiq
        "is-active" if controller_name == "rails_performance" && action_name == "sidekiq"
      when :delayed_job
        "is-active" if controller_name == "rails_performance" && action_name == "delayed_job"
      when :grape
        "is-active" if controller_name == "rails_performance" && action_name == "grape"
      when :rake
        "is-active" if controller_name == "rails_performance" && action_name == "rake"
      when :custom
        "is-active" if controller_name == "rails_performance" && action_name == "custom"
      end
    end
  end
end
