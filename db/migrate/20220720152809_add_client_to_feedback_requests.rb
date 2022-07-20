class AddClientToFeedbackRequests < ActiveRecord::Migration[6.1]
  def change
    add_reference :feedback_requests, :client, null: false, foreign_key: true
  end
end
