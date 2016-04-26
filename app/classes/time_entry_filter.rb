class TimeEntryFilter
  attr_reader :start_date, :end_date, :harvest_wrapper

  def initialize(args = {})
    @start_date = args.fetch(:start_date, Date.today.beginning_of_week)
    @end_date = args.fetch(:end_date, Date.today)
    @harvest_wrapper = Harvest::Wrapper.new
  end



  # def all
  #   entries = TimeEntry.between(start_date, end_date)
  #   entries = entries.map do |entry|
  #     user = users.detect {|u| u["id"] == entry.harvest_user_id }
  #     entry.user_name = [user.first_name, user.last_name].compact.join(" ")
  #     entry
  #   end
  #   entries
  # end

  def users
    @users ||= harvest_wrapper.users
  end

  def active_users
    @users ||= harvest_wrapper.users.find_all(&:is_active?)
  end

  def billable_hours_by_team_member
    hours = active_users.map do |user|
      entries = harvest.reports.time_by_user(user, start_date, end_date, billable: true)
      hash = {
        name: "#{user['first_name']} #{user['last_name']}",
        hours: TimeEntry.rounded_hours(entries)
      }
      hash
    end
    hours
  end

  private

    def harvest
      harvest_wrapper.harvest
    end
end
