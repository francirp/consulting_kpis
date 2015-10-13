class Metrics::Profit < Metrics::Base

  def value
    project.revenue - project.costs
  end

end