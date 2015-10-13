class Project < ActiveRecord::Base
  has_many :time_entries
  belongs_to :client

  include Harvest::Calculations

  def rounded_hours
    time_entries.pluck(:hours).map { |hour| roundup(hour) }.sum
  end

  def profit
    Metrics::Profit.new(project: self).value
  end

  def revenue
    Metrics::Revenue.new(project: self).value
  end

  def costs
    Metrics::Costs.new(project: self).value
  end

end
