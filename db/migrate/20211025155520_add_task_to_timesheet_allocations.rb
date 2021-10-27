class AddTaskToTimesheetAllocations < ActiveRecord::Migration[6.1]
  def change
    add_reference :timesheet_allocations, :task, null: false, foreign_key: true
  end
end
