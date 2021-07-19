class AddUtilizationGoalToContracts < ActiveRecord::Migration[6.1]
  def change
    add_column :contracts, :target_billable_hours_per_year, :integer
    drop_table :utilization_goals
  end
end
