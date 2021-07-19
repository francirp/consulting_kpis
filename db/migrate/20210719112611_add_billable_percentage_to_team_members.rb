class AddBillablePercentageToTeamMembers < ActiveRecord::Migration[6.1]
  def change
    add_column :team_members, :billable_target_ratio, :float
  end
end
