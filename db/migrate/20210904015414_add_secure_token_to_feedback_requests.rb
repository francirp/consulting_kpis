class AddSecureTokenToFeedbackRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :feedback_requests, :token, :string
    add_index :feedback_requests, :token, unique: true
  end
end
