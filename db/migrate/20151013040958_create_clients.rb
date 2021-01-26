class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :harvest_id
      t.boolean :active
      t.datetime :harvest_created_at
      t.datetime :harvest_updated_at
      t.string :statement_key
      t.text :details

      t.timestamps null: false
    end
  end
end
