module AsanaSync
  class SyncUsers
    def initialize;end

    def call
      # projects = Project.all.group_by(&:harvest_id)
      # clients = Client.all.group_by(&:harvest_id)
      team_members = TeamMember.all.group_by(&:email)
       
      keep_fetching = true
      offset_token = nil
      while keep_fetching
        service = AsanaApi::GetUsers.new(offset_token: offset_token)
        service.call
        
        ids = []
        array = service.data.map do |user|
          email = user["email"].try(:downcase)
          team_member = team_members[email].try(:first)
          puts email if team_member.nil?        
          next unless team_member # team member not in harvest, so skip
          ids << team_member.id
          { 
            id: team_member.id,
            asana_id: user["gid"],            
          }
        end.compact # compact to remove the nils from users not in harvest
        TeamMember.update(ids, array)
        offset_token = service.response_offset_token
        keep_fetching = offset_token.present?
      end
    end
  end
end