class Project < ActiveRecord::Base
  has_many :time_entries
  belongs_to :client

  include Harvest::Calculations

  def rounded_hours
    time_entries.pluck(:hours).map { |hour| roundup(hour) }.sum
  end

end
