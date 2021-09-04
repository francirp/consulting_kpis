class Contact < ApplicationRecord
  belongs_to :client

  def all_ready_for_feedback_request
    all
      .where(send_surveys: true)
      .where("last_feedback_request_date < ?", Date.today.beginning_of_month) # been a month since last request
  end

  def send_feedback_request
    date = Date.today
    feedback_request = FeedbackRequest.create(
      contact: self,
      date: date,
    )
    self.last_feedback_request_date = date
    self.save
    ContactMailer.send_feedback_request(email, feedback_request)
  end
end
