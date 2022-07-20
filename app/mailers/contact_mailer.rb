class ContactMailer < ApplicationMailer
  def send_feedback_request(email, feedback_request_id)
    @feedback_request = FeedbackRequest.find(feedback_request_id)
    
    mail(
      to: email_for_environment(email),
      subject: "LaunchPad Lab Pulse Survey",
    ) do |format|
      format.html
    end
  end
end
