class Metrics

  attr_reader :project

  def initialize(args = {})
    @project = args[:project]
  end

  # def self.all
  #   [
  #     {
  #       object: Metrics::Profit.new(project: project),
  #       components: [
  #         Metrics::Revenue.new(project: project),
  #         Metrics::Costs.new(project: project)
  #       ]
  #     }
  #   ]
  # end

end