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

  def stats_icon
    # https://www.iconfinder.com/iconsets/vivid
    '<?xml version="1.0" ?><svg height="48" id="graph-bar" viewBox="0 0 48 48" width="48" xmlns="http://www.w3.org/2000/svg"><defs><style>      .vi-primary {        fill: #FF6E6E;      }      .vi-primary, .vi-accent {        stroke: #fff;        stroke-linecap: round;        stroke-width: 0;      }      .vi-accent {        fill: #0C0058;      }    </style></defs><rect class="vi-accent" height="4" width="36" x="6" y="35"/><path class="vi-primary" d="M9,20h5V35H9V20Zm8,5h5V35H17V25Zm8-9h5V35H25V16Zm8-7h5V35H33V9Z"/></svg>'
  end

  def insert_css_file(file)
    raw "<style>#{raw File.read File.expand_path(File.dirname(__FILE__) + "/../views/stylesheets/#{file}")}</style>"
  end

  def insert_js_file(file)
    raw "<script>#{raw File.read File.expand_path(File.dirname(__FILE__) + "/../views/javascripts/#{file}")}</script>"
  end
end