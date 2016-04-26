class Metrics::ProjectMetrics::Profit < Metrics::ProjectMetrics

  def value
    project.revenue - project.costs
  end

end