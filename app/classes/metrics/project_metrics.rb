class Metrics::ProjectMetrics

  attr_reader :project, :base_metrics

  def initialize(args = {})
    @project = args[:project]
    @base_metrics = args.fetch(:base_metrics, BaseMetrics.new)
    after_init(args)
    require_fields
  end

  private

    def after_init(args = {})
      # implemented by subclasses
    end

    def require_fields
      required_fields.each do |attr|
        raise "#{attr} is a required param for #{self.class.name} class" if send(attr).nil?
      end
    end

    def required_fields
      [:project]
    end

end