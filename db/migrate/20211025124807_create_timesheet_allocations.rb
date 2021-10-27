class CreateTimesheetAllocations < ActiveRecord::Migration[6.1]
  def change
    create_table :timesheet_allocations do |t|
      t.references :timesheet, null: false, foreign_key: true
      t.float :allocation
      t.references :project, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
