class AddEndDateToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :end_date, :date
  end
end
