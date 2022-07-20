class TeamMemberMailer < ApplicationMailer
  def send_feedback_request(email, feedback_request_id)
    @feedback_request = FeedbackRequest.find(feedback_request_id)
    @client = @feedback_request.client 
    subject = "LPL Pulse Survey: #{@client.name}"
    
    mail(
      to: email_for_environment(email),
      subject: subject,
    ) do |format|
      format.html
    end
  end
end
