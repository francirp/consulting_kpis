module HarvestSync
  class PullClients
    def intialize;end

    def call
      array = []
      harvesting_client.clients.each do |client|
        hash = {
          harvest_id: client.id,
          name: client.name,
          active: client.is_active,
          harvest_updated_at: client.updated_at,
          harvest_created_at: client.created_at,
          created_at: Time.now,
          updated_at: Time.now,
        }
        array << hash
      end
      Client.upsert_all(array, unique_by: :harvest_id)
    end
  end
end