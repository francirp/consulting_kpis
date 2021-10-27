class CreateTimesheets < ActiveRecord::Migration[6.1]
  def change
    create_table :timesheets do |t|
      t.references :team_member, null: false, foreign_key: true
      t.date :week
      t.float :non_working_days
      t.integer :status

      t.timestamps
    end
  end
end
