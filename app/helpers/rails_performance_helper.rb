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
    '<?xml version="1.0" ?><svg id="Layer_1" style="enable-background:new 0 0 32 32;" version="1.1" viewBox="0 0 512 512" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><style type="text/css">	.st0{fill:#ED6F62;}	.st1{fill:#FFFFFF;}</style><g id="XMLID_4773_"><circle class="st0" cx="256" cy="256" id="XMLID_4749_" r="256"/><g id="XMLID_5263_"><g id="XMLID_5265_"><g id="XMLID_5268_"><path class="st1" d="M217.8,364.5h-80.5V214.3h80.5V364.5z M143.6,358.2h67.9V220.6h-67.9V358.2z" id="XMLID_5803_"/></g><g id="XMLID_5267_"><path class="st1" d="M309.9,364.5h-80.5V198.4h80.5V364.5z M235.7,358.2h67.9V204.6h-67.9V358.2z" id="XMLID_5800_"/></g><g id="XMLID_5266_"><path class="st1" d="M402,364.5h-80.5V166.4H402V364.5z M327.8,358.2h67.9V172.7h-67.9V358.2z" id="XMLID_5797_"/></g></g><g id="XMLID_5264_"><path class="st1" d="M416,401.2H96V110.8h27.6v262.9H416V401.2z M102.3,395h307.5v-15H117.3V117h-15V395z" id="XMLID_5794_"/></g></g></g></svg>'
  end
end