class AddCostPerHourToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :cost_per_hour, :float
  end
end
