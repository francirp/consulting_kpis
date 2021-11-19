module AsanaApi
  class GetTasks
    attr_reader :client, :start_date, :assignee_id, :offset_token, :response

    def initialize(start_date, opts = {})
      @client = ApiWrapper.new
      @start_date = start_date
      @assignee_id = opts[:assignee_id]
      @offset_token = opts[:offset_token]
    end

    def call
      from = start_date.strftime('%Y%m%d')
      @response = client.get('/1.0/tasks', query: query)
    end

    def data
      response.dig("data")
    end

    private

    def query
      hash = { 
        workspace: client.workspace_id,
        modified_since: start_date,
        limit: 100,        
        opt_fields: fields,
      }
      
      hash[:assignee] = assignee_id if assignee_id
      hash[:offset] = offset_token if offset_token # no offset on first request, only on page 2+
      hash
    end

    def fields
      'name,completed,completed_at,completed_by.name,completed_by.gid,created_at,modified_at,due_on,projects.gid,projects.name,assignee.gid,assignee.name,custom_fields'
    end
  end
end