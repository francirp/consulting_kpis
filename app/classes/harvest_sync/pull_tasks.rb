module HarvestSync
  class PullTasks
    def intialize;end

    def call
      array = []
      harvesting_client.tasks.each do |task|
        hash = {
          harvest_id: task.id,
          name: task.name,
          is_active: task.is_active,
          billable_by_default: task.billable_by_default,
          is_default: task.is_default,
          harvest_updated_at: task.updated_at,
          harvest_created_at: task.created_at,
          created_at: Time.now,
          updated_at: Time.now,
        }
        array << hash
      end
      Task.upsert_all(array, unique_by: :harvest_id)
    end
  end
end