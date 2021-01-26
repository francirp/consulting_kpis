class CreateTimeEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :time_entries do |t|
      t.date :spent_at
      t.integer :harvest_id
      t.text :notes
      t.float :hours
      t.integer :harvest_user_id
      t.integer :harvest_project_id
      t.integer :harvest_task_id
      t.datetime :harvest_created_at
      t.datetime :harvest_updated_at
      t.boolean :is_billed
      t.integer :harvest_invoice_id

      t.timestamps null: false
    end
  end
end
