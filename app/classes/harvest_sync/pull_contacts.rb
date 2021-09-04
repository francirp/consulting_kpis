module HarvestSync
  class PullContacts
    attr_reader :harvest_wrapper

    def intialize;end

    def call
      clients = Client.all.group_by(&:harvest_id)
  
      keep_fetching = true
      page = 1
      while keep_fetching
        puts page
        response = HarvestApi::GetContacts.new(page: page).call
        array = response['contacts'].map do |contact|
          hash = transform_contact(contact)
          hash.merge(
            client_id: clients[contact.dig('client', 'id')].first.id,
          )
        end
        Contact.upsert_all(array, unique_by: :harvest_id)
        keep_fetching = response['total_pages'] > page && response['total_pages']
        page += 1
      end
    end

    private

    def transform_contact(contact)
      {
        harvest_id: contact["id"],
        first_name: contact["first_name"],
        last_name: contact["last_name"],
        email: contact["email"],
        created_at: Time.now,
        updated_at: Time.now,
      }
    end    
  end    
end