class Metrics::Revenue < Metrics::Base

  def value
    project.hourly? ? calculate_revenue : revenue_from_db
  end

  private

    def calculate_revenue
      project.rounded_hours * project.hourly_rate
    end

    def revenue_from_db
      project.revenue || 0.0
    end

end