class AddStartDateToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :start_date, :date
  end
end
