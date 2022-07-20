class AddFeedbackRequestColumnsToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :recent_feedback_request_date, :date
    add_column :team_members, :first_feedback_request_date, :date
    add_column :contacts, :first_feedback_request_date, :date
    add_column :team_members, :send_surveys, :boolean
    rename_column :contacts, :last_feedback_request_date, :recent_feedback_request_date
  end
end
