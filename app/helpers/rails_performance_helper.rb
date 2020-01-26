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
end