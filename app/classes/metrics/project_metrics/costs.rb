class Metrics::ProjectMetrics::Costs < Metrics::ProjectMetrics

  def value
    hours * base_metrics.cost_per_hour
  end

  private

    def hours
      project.rounded_hours || 0.0
    end

end