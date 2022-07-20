class Contact < ApplicationRecord
  include Surveyable
  belongs_to :client

  def send_feedback_request
    set_as_sent # from Surveyable
    feedback_request = FeedbackRequest.create(
      surveyable: self,
      date: Date.current,
      client: client,
    )    
    ContactMailer.send_feedback_request(email, feedback_request.id)
  end
end
