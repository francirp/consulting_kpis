module HarvestApi
  class CreateTimeEntries
    attr_reader :client, :time_entry_hash

    def initialize(time_entry_hash)
      @client = ApiWrapper.new
      @time_entry_hash = time_entry_hash
    end

    def call
      client.post('/v2/time_entries', options)  
    end

    private

    def options
      {
        body: time_entry_hash.to_json
      }
    end    
  end
end