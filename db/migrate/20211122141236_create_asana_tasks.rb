class CreateAsanaTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :asana_tasks do |t|
      t.string :asana_id
      t.string :name
      t.date :completed_on
      t.date :due_on
      t.float :size
      t.integer :unit_type
      t.references :team_member, foreign_key: true
      t.references :asana_project, null: false, foreign_key: true
      t.index [:asana_id], unique: true

      t.timestamps
    end
  end
end
