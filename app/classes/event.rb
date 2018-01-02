class Event
  include ActiveModel::Model
  attr_accessor :group, :name, :date, :time, :duration,
                :waitlisted, :link, :venue, :map_link,
                :source
end
