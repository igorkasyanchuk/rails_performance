class RailsPerformance::Reports::AnnotationsReport
  def data
    {
      xaxis: xaxis
    }
  end

  private

  def xaxis
    RailsPerformance::Events::Record.all.map(&:to_annotation)
  end
end
