class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :harvest_id
      t.integer :harvest_client_id
      t.float :hourly_rate
      t.boolean :hourly

      t.timestamps null: false
    end
  end
end
