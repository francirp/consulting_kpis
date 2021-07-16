module HarvestSync
  class CreateTeamMembers
    def initialize;end

    def call
      harvest = HarvestedWrapper.new
      harvest.users.each do |user|
        TeamMember.find_or_create_by(email: user.email.downcase) do |team_member|
          team_member.harvest_id = user.id
          team_member.first_name = user.first_name
          team_member.last_name = user.last_name
          team_member.is_contractor = user.is_contractor
          team_member.is_active = user.is_active
        end
      end
    end
  end
end