class Project < ActiveRecord::Base
  has_many :time_entries
  belongs_to :client

  include Harvest::Calculations

  def rounded_hours
    TimeEntry.rounded_hours(time_entries)
  end

  def profit
    Metrics::ProjectMetrics::Profit.new(project: self).value
  end

  def revenue
    Metrics::ProjectMetrics::Revenue.new(project: self).value
  end

  def costs
    Metrics::ProjectMetrics::Costs.new(project: self).value
  end

  def profit_margin
    profit / revenue
  end

  def entries_by_year_and_week
    active_weeks = group_by_two_levels(array: time_entries, first: :year, second: :week_num)
    # hash = {}
    # earliest_year = time_entries.earliest.first.try(:year)
    # return [] unless earliest_year
    # latest_year = time_entries.latest.first.try(:year)


    # (earliest_year..latest_year).to_a.each do |year|
    #   (1..52).to_a.each do |week_num|
    #     hash[year] ||= {}
    #     entries = active_weeks[year].try(:[], week_num) || []
    #     hash[year][week_num] = entries
    #   end
    # end
    # return hash
  end

  def group_by_two_levels(args = {})
    array, first, second = [args[:array], args[:first], args[:second]]
    hash = array.group_by do |obj|
      obj.respond_to?(first) ? obj.send(first) : obj[first]
    end
    hash.each do |first, obj_array|
      hash[first] = obj_array.group_by do |obj|
        obj.respond_to?(second) ? obj.send(second) : obj[second]
      end
    end
    hash
  end
end
