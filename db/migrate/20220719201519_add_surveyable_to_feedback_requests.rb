class AddSurveyableToFeedbackRequests < ActiveRecord::Migration[6.1]
  def change
    remove_reference :feedback_requests, :contact
    add_reference :feedback_requests, :surveyable, polymorphic: true, null: false
  end
end
