class CreateAsanaProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :asana_projects do |t|
      t.string :asana_id
      t.string :name
      t.boolean :archived
      t.index [:asana_id], unique: true
      t.timestamps
    end
  end
end
