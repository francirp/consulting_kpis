module HarvestApi
  class ApiWrapper
    include HTTParty
    base_uri 'https://api.harvestapp.com'

    attr_reader :token, :account_id

    def initialize
      @token ||= ENV["HARVEST_ACCESS_TOKEN"]
      @account_id ||= ENV["HARVEST_ACCOUNT_ID"]
    end

    def get(endpoint, options = {})
      self.class.get(endpoint, options.merge(default_options))
    end

    def post(endpoint, options = {})
      self.class.post(endpoint, options.merge(default_options))
    end    

    private
    
    def default_options
      {
        headers: {
          'Authorization' => "Bearer #{token}",
          'Harvest-Account-Id' => account_id,
          'User-Agent' => "Consulting KPIs (ryan@launchpadlab.com)",          
          'Content-Type' => 'application/json',
        }
      }
    end    
  end
end