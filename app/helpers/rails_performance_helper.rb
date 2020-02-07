module RailsPerformanceHelper
  def round_it(value)
    return nil unless value
    return value if value.is_a?(Integer)

    value.nan? ? nil : value.round(2)
  end

  def statistics_link(title, report, group)
    options = case report.group
    when :controller_action_format
      ca = group.split("|")
      c, a = ca[0].split("#")
      {
        controller_eq: c,
        action_eq: a,
        format_eq: ca[1]
      }
    else
      {}
    end

    link_to title, rails_performance_path(options), target: '_blank'
  end

  def status_tag(status)
    klass = case status.to_s
    when /^5/
      "tag is-danger"
    when /^4/
      "tag is-warning"
    when /^3/
      "tag is-info"
    when /^2/
      "tag is-success"
    else
      nil
    end
    content_tag(:span, class: klass) do
      status
    end
  end

  def stats_icon
    # https://www.iconfinder.com/iconsets/vivid
    raw File.read(File.expand_path(File.dirname(__FILE__) +  "/../assets/images/stat.svg"))
  end

  def insert_css_file(file)
    raw "<style>#{raw File.read File.expand_path(File.dirname(__FILE__) + "/../views/stylesheets/#{file}")}</style>"
  end

  def insert_js_file(file)
    raw "<script>#{raw File.read File.expand_path(File.dirname(__FILE__) + "/../views/javascripts/#{file}")}</script>"
  end
end