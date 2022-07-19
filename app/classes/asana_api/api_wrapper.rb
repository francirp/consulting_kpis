module AsanaApi
  class ApiWrapper
    include HTTParty
    base_uri 'https://app.asana.com/api'

    attr_reader :token, :workspace_id

    def initialize
      @token ||= ENV["ASANA_API_TOKEN"]
      @workspace_id ||= "10172721516874"
    end

    def get(endpoint, options = {})
      self.class.get(endpoint, options.merge(default_options))
    end

    private
    
    def default_options
      {
        headers: {
          "Authorization" => "Bearer #{token}",
          "Accept" => "application/json",
        }
      }
    end    
  end
end