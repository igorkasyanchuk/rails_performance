module RailsPerformanceHelper
  def round_it(value)
    return nil unless value
    return value if value.is_a?(Integer)

    value.nan? ? nil : value.round(2)
  end

  def ms(value)
    result = round_it(value)
    result ? "#{result} ms" : '-'
  end

  def short_path(path, length: 60)
    tag.span title: path do
      truncate(path, length: length)
    end
  end

  def link_to_path(e)
    if e[:method] == 'GET'
      link_to short_path(e[:path]), e[:path], target: '_blank'
    else
      short_path(e[:path])
    end
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

  def icon(name)
    # https://www.iconfinder.com/iconsets/vivid
    raw File.read(File.expand_path(File.dirname(__FILE__) +  "/../assets/images/#{name}.svg"))
  end

  def insert_css_file(file)
    raw "<style>#{raw File.read File.expand_path(File.dirname(__FILE__) + "/../views/stylesheets/#{file}")}</style>"
  end

  def insert_js_file(file)
    raw "<script>#{raw File.read File.expand_path(File.dirname(__FILE__) + "/../views/javascripts/#{file}")}</script>"
  end

  def format_datetime(e)
    e.strftime("%Y-%m-%d %H:%M:%S")
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
    end
  end
end