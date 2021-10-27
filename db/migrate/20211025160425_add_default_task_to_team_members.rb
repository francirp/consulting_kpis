class AddDefaultTaskToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_reference :team_members, :task, foreign_key: true
  end
end
