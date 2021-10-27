class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.boolean :is_active
      t.integer :harvest_id
      t.boolean :billable_by_default
      t.string :name
      t.boolean :is_default
      t.datetime :harvest_created_at
      t.datetime :harvest_updated_at
      t.index ["harvest_id"], name: "index_tasks_on_harvest_id", unique: true
      t.timestamps
    end
  end
end
