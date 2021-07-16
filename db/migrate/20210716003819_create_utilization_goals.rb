class CreateUtilizationGoals < ActiveRecord::Migration[6.1]
  def change
    create_table :utilization_goals do |t|
      t.references :team_member, null: false, foreign_key: true
      t.integer :annualized_hours
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
