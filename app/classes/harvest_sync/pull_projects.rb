module HarvestSync
  class PullProjects
    attr_reader :harvest_wrapper

    def intialize(args = {})
      @harvest_wrapper = HarvestedWrapper.new
    end

    def call
      array = []
      harvesting_client.projects.each do |project|
        hash = {
          harvest_id: project.id,
          name: project.name,
          harvest_client_id: project.client.id,
          hourly_rate: project.hourly_rate,
          hourly: project.hourly_rate.present?,
          created_at: Time.now,
          updated_at: Time.now,
        }
        array << hash
      end
      Project.upsert_all(array, unique_by: :harvest_id)
    end
  end
end