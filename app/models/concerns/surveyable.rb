# this concern is for any models that leverage the "FeedbackRequest" model.
# any including model must have the following columns:
#   - send_surveys (boolean)
#   - 
module Surveyable
  extend ActiveSupport::Concern

  included do
    has_many :feedback_requests, :as => :surveyable
  end

  class_methods do
    def all_ready_for_feedback_request(opts = {})
      all
        .where(send_surveys: true)
        .where("recent_feedback_request_date <= ?", Date.current - 14.days) # send requests every sprint - been a sprint since last request was sent
        .where("first_feedback_request_date <= ?", Date.current) # first sprint has taken place (so we can schedule out the cadence in advance)
    end
  end

  def set_as_sent
    date = Date.current
    self.recent_feedback_request_date = date
    self.save
  end
end