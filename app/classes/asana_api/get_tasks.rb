module AsanaApi
  class GetTasks
    attr_reader :client, :start_date, :project_id, :assignee_id, :offset_token, :response

    def initialize(start_date, opts = {})
      @client = ApiWrapper.new
      @start_date = start_date
      @project_id = opts[:project_id]
      @assignee_id = opts[:assignee_id]
      @offset_token = opts[:offset_token]
    end

    def call
      from = start_date.strftime('%Y%m%d')
      @response = client.get('/1.0/tasks', query: query)
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
        modified_since: start_date,
        limit: 100,        
        opt_fields: fields,
      }
      
      if assignee_id
        hash[:assignee] = assignee_id 
        hash[:workspace] = client.workspace_id # must specify workplace when assignee is used to filter
      end
      
      hash[:project] = project_id if project_id
      hash[:offset] = offset_token if offset_token # no offset on first request, only on page 2+
      hash
    end

    def fields
      'name,completed,completed_at,completed_by.name,completed_by.gid,created_at,modified_at,due_on,projects.gid,projects.name,assignee.gid,assignee.name,custom_fields'
    end
  end
end