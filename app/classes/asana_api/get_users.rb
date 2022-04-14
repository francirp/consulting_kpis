module AsanaApi
  class GetUsers
    attr_reader :client, :offset_token, :response

    def initialize(opts = {})
      @client = ApiWrapper.new
      @offset_token = opts[:offset_token]
    end

    def call
      @response = client.get('/1.0/users', query: query)
      @response
    end

    def response_offset_token
      response.dig("next_page", "offset")
    end

    def data
      response.dig('data')
    end

    private

    def query
      hash = { 
        workspace: client.workspace_id,
        limit: 100,        
        opt_fields: fields,
      }

      hash[:offset] = offset_token if offset_token # no offset on first request, only on page 2+
      hash
    end

    def fields
      'name,email,gid'
    end
  end
end