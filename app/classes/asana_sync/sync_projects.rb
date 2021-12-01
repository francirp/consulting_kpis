module AsanaSync
  class SyncProjects
    def initialize;end

    def call
      projects = AsanaProject.all.group_by(&:asana_id)
       
      keep_fetching = true
      offset_token = nil
      while keep_fetching
        service = AsanaApi::GetProjects.new(offset_token: offset_token)
        service.call
        
        ids = []
        array = service.data.map do |project|
          existing_project = projects.detect { |p| p.asana_id == project["gid"] }
          puts project
          { 
            asana_id: project["gid"],            
            name: project["name"],            
            archived: project["archived"] || existing_project.ignore?, # archive any projects that we have flagged as "ignore"            
            created_at: DateTime.parse(project["created_at"]),            
            updated_at: DateTime.parse(project["modified_at"]),            
          }
        end
        AsanaProject.upsert_all(array, unique_by: :asana_id)
        offset_token = service.response_offset_token
        keep_fetching = offset_token.present?
      end
    end
  end
end