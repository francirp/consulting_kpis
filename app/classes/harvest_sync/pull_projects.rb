module HarvestSync
  class PullProjects
    def intialize;end

    def call
      clients = Client.all.group_by(&:harvest_id)
      array = []
      harvesting_client.projects.each do |project|
        hash = {
          harvest_id: project.id,
          name: project.name,
          harvest_client_id: project.client.id,
          hourly_rate: project.hourly_rate,
          hourly: project.hourly_rate.present?,
          is_active: project.is_active,
          is_billable: project.is_billable,
          created_at: Time.now,
          updated_at: Time.now,
        }
        hash.merge!(
          client_id: clients[project.client.id].first.id,
        )
        array << hash
      end
      Project.upsert_all(array, unique_by: :harvest_id)
    end
  end
end