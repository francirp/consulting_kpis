class Metrics::Costs < Metrics::Base

  def value
    hours * base_metrics.cost_per_hour
  end

  private

    def hours
      project.rounded_hours || 0.0
    end

end