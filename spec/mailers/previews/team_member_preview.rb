# Preview all emails at http://localhost:3000/rails/mailers/team_member
class TeamMemberPreview < ActionMailer::Preview
  def send_feedback_request
    team_member = TeamMember.find_by(first_name: 'dummy-person') || FactoryBot.create(:team_member, first_name: 'dummy-person')
    client = Client.find_by(name: 'dummy-client') || FactoryBot.create(:client, name: 'dummy-client')
    feedback_request = FactoryBot.create(:feedback_request, surveyable: team_member, client: client, date: Date.current)
    TeamMemberMailer.send_feedback_request("ryan@launchpadlab.com", feedback_request.id)
  end
end
