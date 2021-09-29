module HarvestSync
  class PullTimeEntries
    attr_reader :start_date, :end_date

    def initialize(args = {})
      @start_date = args.fetch(:start_date, Date.today - 1.week)
      @end_date = args.fetch(:end_date, Date.today.end_of_year)
    end

    def call
      projects = Project.all.group_by(&:harvest_id)
      clients = Client.all.group_by(&:harvest_id)
      team_members = TeamMember.all.group_by(&:harvest_id)
  
      keep_fetching = true
      page = 1
      while keep_fetching
        puts page
        response = HarvestApi::GetTimeEntries.new(start_date, end_date, page: page).call
        array = response['time_entries'].map do |entry|
          hash = transform_time_entry(entry)
          hash.merge(
            client_id: clients[entry.dig('client', 'id')].first.id,
            project_id: projects[entry.dig('project', 'id')].first.id,
            team_member_id: team_members[entry.dig('user', 'id')].first.id,
          )
        end
        TimeEntry.upsert_all(array, unique_by: :harvest_id)
        keep_fetching = response['total_pages'] > page && response['total_pages']
        page += 1
      end
    end

    private

    def transform_time_entry(entry)
      {
        spent_at: entry["spent_date"],
        harvest_id: entry["id"],
        notes: entry["notes"],
        hours: entry["hours"],
        rounded_hours: entry["rounded_hours"],
        billable: entry["billable"],
        billable_rate: entry["billable_rate"],
        cost_rate: entry["cost_rate"],
        harvest_user_id: entry.dig('user', 'id'),
        harvest_project_id: entry.dig('project', 'id'),
        harvest_client_id: entry.dig('client', 'id'),
        harvest_task_id: entry.dig('task', 'id'),
        harvest_created_at: entry["created_at"],
        harvest_updated_at: entry["updated_at"],
        created_at: entry["created_at"],
        updated_at: entry["updated_at"],        
        is_billed: entry["is_billed"],
        harvest_invoice_id: entry.dig('invoice', 'id'),
      }
    end
  end
end