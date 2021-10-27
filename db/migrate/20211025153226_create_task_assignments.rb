class CreateTaskAssignments < ActiveRecord::Migration[6.1]
  def change
    create_table :task_assignments do |t|
      t.references :project, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.boolean :is_active
      t.integer :harvest_id
      t.index ["harvest_id"], name: "index_task_assignments_on_harvest_id", unique: true

      t.timestamps
    end
  end
end
